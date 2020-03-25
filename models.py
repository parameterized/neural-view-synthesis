
import os
from keras.models import Model
from keras.layers import Input, Reshape, Lambda
from keras.layers import Conv2D, Conv3D, UpSampling2D, ZeroPadding2D


class V1:
    def __init__(self):
        """Model 1: 6 -> 64 -> 3"""
        self.l_in = Input(shape=(None, None, 6))
        self.l_conv1 = Conv2D(64, kernel_size=(1, 1), activation='relu', kernel_initializer='he_normal')
        self.l_conv2 = Conv2D(3, kernel_size=(1, 1))

        h_conv1 = self.l_conv1(self.l_in)
        h_conv2 = self.l_conv2(h_conv1)

        self.model = Model(self.l_in, h_conv2)

    def serialize_lua(self):
        [d1_kernel, d1_bias] = self.l_conv1.get_weights()
        d1_kernel = d1_kernel[0, 0]  # all 1x1
        [d2_kernel, d2_bias] = self.l_conv2.get_weights()
        d2_kernel = d2_kernel[0, 0]

        rows = ['{{ {} }}'.format(','.join([str(v) for v in row]))
                for row in d1_kernel]
        d1_kernel_s = '{{ {} }}'.format(',\n'.join(rows))
        d1_bias_s = '{{ {} }}'.format(','.join([str(v) for v in d1_bias]))

        rows = ['{{ {} }}'.format(','.join([str(v) for v in row]))
                for row in d2_kernel]
        d2_kernel_s = '{{ {} }}'.format(',\n'.join(rows))
        d2_bias_s = '{{ {} }}'.format(','.join([str(v) for v in d2_bias]))

        s = """
return {{

    d1_kernel = {},

    d1_bias = {},

    d2_kernel = {},

    d2_bias = {}

}}
""".format(d1_kernel_s, d1_bias_s, d2_kernel_s, d2_bias_s)

        os.makedirs('models', exist_ok=True)
        with open('models/weights_v1.lua', 'w') as f:
            f.write(s)


class V2:
    def __init__(self):
        """Model 2: 6 -> 3 dense(128) -> 3"""
        self.l_in = Input(shape=(None, None, 6))
        self.l_conv1 = Conv2D(128, kernel_size=(1, 1), activation='relu', kernel_initializer='he_normal')
        self.l_conv2 = Conv2D(128, kernel_size=(1, 1), activation='relu', kernel_initializer='he_normal')
        self.l_conv3 = Conv2D(128, kernel_size=(1, 1), activation='relu', kernel_initializer='he_normal')
        self.l_conv4 = Conv2D(3, kernel_size=(1, 1))

        h_conv1 = self.l_conv1(self.l_in)
        h_conv2 = self.l_conv2(h_conv1)
        h_conv3 = self.l_conv3(h_conv2)
        h_conv4 = self.l_conv4(h_conv3)

        self.model = Model(self.l_in, h_conv4)


class V3:
    def __init__(self):
        """Model 3: (64, 36) -> 6 2-strided conv1d(64) -> 3"""
        self.l_in = Input(shape=(None, None, 64, 36))
        self.conv_layers = []
        for i in range(6):
            self.conv_layers.append(Conv3D(64, kernel_size=(1, 1, 2), strides=(1, 1, 2), activation='relu', kernel_initializer='he_normal'))
        self.conv_layers.append(Conv3D(3, kernel_size=(1, 1, 1)))

        h = self.l_in
        for cl in self.conv_layers:
            h = cl(h)

        h_out = Lambda(lambda x: x[..., 0, :], output_shape=lambda s: s[:-2] + s[-1:])(h)
        self.model = Model(self.l_in, h_out)


class V4:
    def __init__(self):
        """Model 4: 6 -> (1, 1, 6) -> 4 (upsampling2d(4) + conv2d(32)) -> conv2d(32) -> (256, 256, 3)"""
        self.l_in = Input(shape=(6,))
        self.conv_layers = []

        h = Reshape((1, 1, 6))(self.l_in)
        for i in range(5):
            if i != 4:
                h = UpSampling2D((4, 4))(h)
            h = ZeroPadding2D((2, 2))(h)
            self.conv_layers.append(Conv2D(8, kernel_size=(5, 5), padding='valid', activation='relu', kernel_initializer='he_normal'))
            h = self.conv_layers[-1](h)

        self.conv_layers.append(Conv2D(3, kernel_size=(3, 3)))
        h = ZeroPadding2D((1, 1))(h)
        h = self.conv_layers[-1](h)
        self.model = Model(self.l_in, h)

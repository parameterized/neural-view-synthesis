
import json
import numpy as np
from keras.preprocessing.image import load_img, img_to_array


def get_rays(data, c2w):
    i, j = np.meshgrid(np.arange(data.W, dtype=np.float32),
                       np.arange(data.H, dtype=np.float32), indexing='xy')
    dirs = [(i - data.W * 0.5) / data.focal,
            -(j - data.H * 0.5) / data.focal,
            -np.ones_like(i)]
    dirs = np.stack(dirs, -1)
    rays_d = np.sum(dirs[..., np.newaxis, :] * c2w[:3, :3], -1)
    rays_o = np.broadcast_to(c2w[:3, -1], np.shape(rays_d))
    return rays_o, rays_d

def data_generator(data, batch_size=8, patch_size=8, random_rays=True):
    ps = patch_size
    while True:
        if random_rays:
            batch_shape = (batch_size, ps, ps)
            data_idxs = np.random.randint(data.X.shape[0], size=batch_shape)
            pys = np.random.randint(data.X.shape[1], size=batch_shape)
            pxs = np.random.randint(data.X.shape[2], size=batch_shape)
            batch_x = data.X[data_idxs, pys, pxs]
            batch_y = data.y[data_idxs, pys, pxs]
        else:
            batch_x = np.zeros((batch_size, ps, ps, 6))
            batch_y = np.zeros((batch_size, ps, ps, 3))
            for b_idx in range(batch_size):
                data_idx = np.random.randint(data.X.shape[0])
                py = np.random.randint(data.H - ps)
                px = np.random.randint(data.W - ps)
                batch_x[b_idx] = data.X[data_idx, py:py + ps, px:px + ps]
                batch_y[b_idx] = data.y[data_idx, py:py + ps, px:px + ps]
        yield batch_x, batch_y


class Data:
    def __init__(self, scene='lego', mode='train'):
        """Load data

        scene: 'lego'
        mode: 'train', 'test', 'val'
        """

        data_path = 'data/{}/{}'.format(scene, mode)
        self.imgs = []
        for i in range(100):
            img = load_img('{}/r_{}.png'.format(data_path, i))
            self.imgs.append(img_to_array(img) / 255.)

        with open('data/{}/transforms_{}.json'.format(scene, mode), 'r') as f:
            transforms_json = json.load(f)

        self.camera_angle_x = transforms_json['camera_angle_x']
        self.transforms = [{
            'rotation': v['rotation'],
            'c2w_matrix': np.array(v['transform_matrix'])
        } for v in transforms_json['frames']]

        self.H, self.W = self.imgs[0].shape[:2]
        self.focal = 0.5 * self.W / np.tan(0.5 * self.camera_angle_x)
        self.near = 2.
        self.far = 6.

        self.X = []
        for t in self.transforms:
            x = np.concatenate(get_rays(self, t['c2w_matrix']), -1)
            self.X.append(np.expand_dims(x, 0))

        self.X = np.concatenate(self.X, 0)
        self.y = np.concatenate([np.expand_dims(img, 0) for img in self.imgs], 0)

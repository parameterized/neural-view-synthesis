
import os
from keras.optimizers import Adam
from models import V1, V2
from data import Data, data_generator


v1 = V1()
model = v1.model
model.compile(optimizer=Adam(0.001), loss='mse')

data = Data('lego', 'train')

model.fit_generator(data_generator(data), steps_per_epoch=1.25e5, epochs=1)
os.makedirs('models', exist_ok=True)
model.save('models/m1.h5')

v1.serialize_lua()

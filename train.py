
import os
from keras.optimizers import Adam
from models import V3
from data import Data, embedded_data_generator


v3 = V3()
model = v3.model
model.compile(optimizer=Adam(0.001), loss='mse')

data = Data('lego', 'train')

model.fit_generator(embedded_data_generator(data), steps_per_epoch=1.25e5, epochs=1)
os.makedirs('models', exist_ok=True)
model.save('models/m3.h5')

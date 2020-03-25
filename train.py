
import os
from keras.optimizers import Adam
from models import V4
from data import Data, camera_data_generator


print('Building model...')
v4 = V4()
model = v4.model
model.compile(optimizer=Adam(0.001), loss='mse')

print('Loading Data...')
data = Data('lego', 'train', resize=256)

print('Training...')
# actual steps_per_epoch = 12.5
model.fit_generator(camera_data_generator(data), steps_per_epoch=100, epochs=5)
os.makedirs('models', exist_ok=True)
model.save('models/m4.h5')
print('Training complete')

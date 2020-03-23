
import os
import numpy as np
from tqdm import tqdm
from keras.models import load_model
from keras.preprocessing.image import save_img
import moviepy.editor as mvp
from data import Data, get_rays


model_path = 'models/m1.h5'
video_path = 'videos/v1.mp4'
model = load_model(model_path)

data = Data('lego', 'test')

print('Generating video...')
os.makedirs('video_frames', exist_ok=True)
frame_paths = []
for i, t in tqdm(enumerate(data.transforms), total=len(data.transforms)):  
    x = np.concatenate(get_rays(data, t['c2w_matrix']), -1)
    x = np.expand_dims(x, 0)
    y = model.predict(x)[0]
    p = 'video_frames/{}.png'.format(i)
    save_img(p, y)
    frame_paths.append(p)

os.makedirs('videos', exist_ok=True)
mvp.ImageSequenceClip(frame_paths, fps=30.0).write_videofile(video_path)

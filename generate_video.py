
import os
import numpy as np
from tqdm import tqdm
from keras.models import load_model
from keras.preprocessing.image import save_img
import moviepy.editor as mvp
from data import Data, get_rays, get_embedding


model_path = 'models/m3.h5'
video_path = 'videos/v3.mp4'
model = load_model(model_path)

data = Data('lego', 'test')

print('Generating video...')
os.makedirs('video_frames', exist_ok=True)
frame_paths = []

def gen_v1():
    for i, t in tqdm(enumerate(data.transforms), total=len(data.transforms)):  
        x = np.concatenate(get_rays(data, t['c2w_matrix']), -1)
        x = np.expand_dims(x, 0)
        y = model.predict(x)[0]
        path = 'video_frames/{}.png'.format(i)
        save_img(path, y)
        frame_paths.append(p)

def gen_v3():
    for i, t in tqdm(enumerate(data.transforms), total=len(data.transforms)):
        rays = get_rays(data, t['c2w_matrix'])
        y = np.zeros((data.H, data.W, 3))
        # requires 11gb for full image -> do in 16 patches
        ph = data.H // 4
        pw = data.W // 4
        for pi in range(4):
            for pj in range(4):
                py = pi * ph
                px = pj * pw
                x = get_embedding(rays[py:py + ph, px:px + pw])
                x = np.expand_dims(x, 0)
                patch_img = model.predict(x)[0]
                y[py:py + ph, px:px + pw] = patch_img
        path = 'video_frames/{}.png'.format(i)
        save_img(path, y)
        frame_paths.append(path)

gen_v3()

os.makedirs('videos', exist_ok=True)
mvp.ImageSequenceClip(frame_paths, fps=30.0).write_videofile(video_path)

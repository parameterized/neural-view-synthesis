
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
    return np.concatenate((rays_o, rays_d), -1)

def get_embedding(rays, n_freqs=10, n_steps=64, start=0, stop=6):
    os = np.repeat(rays[..., np.newaxis, :3], n_steps, -2)
    ds = np.repeat(rays[..., np.newaxis, 3:], n_steps, -2)
    dists = np.repeat(np.linspace(start, stop, n_steps)[:, np.newaxis], 3, -1)
    points = os + ds * dists
    embed_vals = [points, ds]
    for L in range(n_freqs):
        for d in range(3):
            embed_vals.append(np.sin(2**L * np.pi * points[..., [d]]))
    return np.concatenate(embed_vals, -1)

def ray_data_generator(data, batch_size=8, patch_size=8, random_rays=True):
    ps = patch_size
    while True:
        if random_rays:
            batch_shape = (batch_size, ps, ps)
            data_idxs = np.random.randint(data.rays.shape[0], size=batch_shape)
            pys = np.random.randint(data.rays.shape[1], size=batch_shape)
            pxs = np.random.randint(data.rays.shape[2], size=batch_shape)
            batch_x = data.rays[data_idxs, pys, pxs]
            batch_y = data.imgs[data_idxs, pys, pxs]
        else:
            batch_x = np.zeros((batch_size, ps, ps, 6))
            batch_y = np.zeros((batch_size, ps, ps, 3))
            for b_idx in range(batch_size):
                data_idx = np.random.randint(data.rays.shape[0])
                py = np.random.randint(data.H - ps)
                px = np.random.randint(data.W - ps)
                batch_x[b_idx] = data.rays[data_idx, py:py + ps, px:px + ps]
                batch_y[b_idx] = data.imgs[data_idx, py:py + ps, px:px + ps]
        yield batch_x, batch_y

def embedded_data_generator(data, batch_size=8, patch_size=8, random_rays=True, n_freqs=10, n_steps=64, start=0, stop=6):
    ps = patch_size
    while True:
        if random_rays:
            batch_shape = (batch_size, ps, ps, n_steps)
            data_idxs = np.random.randint(data.rays.shape[0], size=batch_shape[:-1])
            pys = np.random.randint(data.rays.shape[1], size=batch_shape[:-1])
            pxs = np.random.randint(data.rays.shape[2], size=batch_shape[:-1])
            batch_rays = data.rays[data_idxs, pys, pxs]
            batch_x = get_embedding(batch_rays, n_freqs, n_steps, start, stop)
            batch_y = data.imgs[data_idxs, pys, pxs]
        else:
            batch_rays = np.zeros((batch_size, ps, ps, 6))
            batch_y = np.zeros((batch_size, ps, ps, 3))
            for b_idx in range(batch_size):
                data_idx = np.random.randint(data.rays.shape[0])
                py = np.random.randint(data.H - ps)
                px = np.random.randint(data.W - ps)
                batch_rays[b_idx] = data.rays[data_idx, py:py + ps, px:px + ps]
                batch_y[b_idx] = data.imgs[data_idx, py:py + ps, px:px + ps]
            batch_x = get_embedding(batch_rays, n_freqs, n_steps, start, stop)
        yield batch_x, batch_y

def camera_data_generator(data, batch_size=8):
    while True:
        batch_x = np.zeros((batch_size, 6))
        batch_y = np.zeros((batch_size, data.H, data.W, 3))
        for b_idx in range(batch_size):
            data_idx = np.random.randint(len(data.transforms))
            c2w = data.transforms[data_idx]['c2w_matrix']
            cam_d = np.sum(np.array([[0, 0, -1]]) * c2w[:3, :3], -1)
            cam_o = c2w[:3, -1]
            batch_x[b_idx] = np.concatenate((cam_o, cam_d), -1)
            batch_y[b_idx] = data.imgs[data_idx]
        yield batch_x, batch_y


class Data:
    def __init__(self, scene='lego', mode='train', resize=None):
        """Load data

        scene: 'lego'
        mode: 'train', 'test', 'val'
        resize: None or value for width & height (ex: 512)
        """

        data_path = 'data/{}/{}'.format(scene, mode)
        self.imgs = []
        for i in range(100):
            self.imgs.append(load_img('{}/r_{}.png'.format(data_path, i)))

        with open('data/{}/transforms_{}.json'.format(scene, mode), 'r') as f:
            transforms_json = json.load(f)

        self.camera_angle_x = transforms_json['camera_angle_x']
        self.transforms = [{
            'rotation': v['rotation'],
            'c2w_matrix': np.array(v['transform_matrix'])
        } for v in transforms_json['frames']]

        if resize == None:
            self.W, self.H = self.imgs[0].size
        else:
            self.W, self.H = resize, resize
            self.imgs = [img.resize((self.W, self.H)) for img in self.imgs]

        self.imgs = [img_to_array(img) / 255. for img in self.imgs]

        self.focal = 0.5 * self.W / np.tan(0.5 * self.camera_angle_x)
        self.near = 2.
        self.far = 6.

        self.rays = []
        for t in self.transforms:
            self.rays.append(get_rays(self, t['c2w_matrix']))

        self.rays = np.stack(self.rays, 0)
        self.imgs = np.stack(self.imgs, 0)

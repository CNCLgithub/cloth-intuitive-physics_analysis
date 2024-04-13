import os, math, random
import numpy as np
from matplotlib.patches import Ellipse
from sklearn.datasets import make_blobs
import matplotlib.pyplot as plt


def calc_p (x):
    return 2 * np.min([
        np.mean(np.array(x) >= 0),
        np.mean(np.array(x) <= 0)
    ])

def calc_diff_p(a, b):
    random.seed(0)
    random.shuffle(a)
    random.shuffle(b)
    return calc_p(a-b)
    

def ci_95(x):
    return np.percentile(x, [2.5, 97.5])

def log4(x, base=4):
    from math import log
    return log(float(x),base)

def label_point(x, y, val, ax):
    import pandas as pd
    a = pd.concat({'x': x, 'y': y, 'val': val}, axis=1)
    for i, point in a.iterrows():
        ax.text(point['x'], point['y'], str(point['val']))


def load_json(f):
    import json
    with open(f, 'r') as file:
        data = json.load(file)
    return data


def draw_ellipse(position, covariance, ax=None, titles=None, **kwargs):
    """Draw an ellipse with a given position and covariance"""
    ax = ax or plt.gca()
    # Convert covariance to principal axes
    if covariance.shape == (2, 2):
        U, s, Vt = np.linalg.svd(covariance)
        angle = np.degrees(np.arctan2(U[1, 0], U[0, 0]))
        width, height = 2 * np.sqrt(s)
    else:
        angle = 0
        width, height = 2 * np.sqrt(covariance)
    
    for nsig in range(1, 4):
        ax.add_patch(Ellipse(position, nsig * width, nsig * height,
                             angle, **kwargs))
    plt.plot(position[0], position[1], 'go')
    angle_rad = angle/(180/math.pi)
    m = np.tan(angle_rad)
    x = np.arange(-4, 4)
    b = position[1] - m * position[0]
    line1 = plt.plot(x, m*x + b)
    ax.set_ylim(0, 6)
    ax.text(position[0]+3, position[1]+3, "y={}*x+{}, angle={}".format(round(m, 3), round(b, 3), round(angle, 3)), fontsize = 12)

    
def plot_gmm(gmm, X, label=True, ax=None, titles=None, fig_idx=0):
    plt.figure(fig_idx)
    ax = ax or plt.gca()
    ax = plt.gca()
    labels = gmm.fit(X).predict(X)
    if label:
        ax.scatter(X[:, 0], X[:, 1], c=labels, s=40, cmap='viridis', zorder=2)
    else:
        ax.scatter(X[:, 0], X[:, 1], s=40, zorder=2)
    ax.axis('equal')
    plt.title(titles)

    w_factor = 0.2 / gmm.weights_.max()
    for pos, covar, w in zip(gmm.means_, gmm.covariances_, gmm.weights_):
        draw_ellipse(pos, covar, alpha=w * w_factor, titles=titles)
        
        
def fit_gmm(gmm, X):
    gmm.fit(X)
    covariance = np.squeeze(gmm.covariances_)
    
    # Convert covariance to principal axes
    if covariance.shape == (2, 2):
        U, s, Vt = np.linalg.svd(covariance)
        angle = np.degrees(np.arctan2(U[1, 0], U[0, 0]))
        width, height = 2 * np.sqrt(s)
    else:
        angle = 0
        width, height = 2 * np.sqrt(covariance)
    return angle

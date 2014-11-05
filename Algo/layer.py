import numpy as np

__all__ = ['layer']

def layer(pos, arr):
    '''pos: current x,y position
    arr: 2d numpy array of bool
    generates instructions for pass from left to right (0 to n)'''
    any_list = np.any(arr, axis=1)
    left = any_list.argmin()
    right = any_list.argmax()
    
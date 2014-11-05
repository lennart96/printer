import numpy as np

__all__ = ['layer']

def d(a, b):
    return abs(a - b)

def lr(arr):
    any_list = np.any(arr, axis=1)
    return tb(any_list)

def tb(arr):
    for _ in range AAAA

def handle_layer(printer, layer):
    w, h = layer.shape
    left, right = lr(layer)
    reverse = d(x, left) > d(x, right)

    if reverse:
        arr = np.fliplr(layer)
        printer.fliplr()

    handle_layer_from_left((x, y), layer)

    if reverse:
        printer.fliplr()

def handle_layer_from_left(printer, layer):
    '''pos: current x,y position
    arr: 2d numpy array of bool
    generates instructions for pass from left to right (0 to n)'''
    w, h = layer.shape
    left, right = lr(layer)
    
    for i in range(left, right):
        handle_column
    
    
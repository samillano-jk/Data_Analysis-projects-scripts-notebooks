import numpy as np


def calculate(list):
    calculations = {
        "mean": [], 
        "variance": [],
        "standard deviation": [],
        "max": [],
        "min": [],
        "sum": []
    }

    if len(list) >= 9: 
        num_array = np.array(list).reshape(3,3)
        calculations["mean"] += [num_array.mean(axis=0).tolist(), num_array.mean(axis=1).tolist(), num_array.mean()]
        calculations["variance"] += [num_array.var(axis=0).tolist(), num_array.var(axis=1).tolist(), num_array.var()]              
        calculations["standard deviation"] += [num_array.std(axis=0).tolist(), num_array.std(axis=1).tolist(), num_array.std()]        
        calculations["max"] += [num_array.max(axis=0).tolist(), num_array.max(axis=1).tolist(), num_array.max()]
        calculations["min"] += [num_array.min(axis=0).tolist(), num_array.min(axis=1).tolist(), num_array.min()]      
        calculations["sum"] += [num_array.sum(axis=0).tolist(), num_array.sum(axis=1).tolist(), num_array.sum()]

    else: 
        raise ValueError("List must contain nine numbers.")


    return calculations
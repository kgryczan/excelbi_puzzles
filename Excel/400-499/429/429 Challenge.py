import pandas as pd
import numpy as np
import math

input = pd.read_excel("429 Pythagorean Quadruples.xlsx", sheet_name="Sheet1", usecols="A", nrows=10)
test = pd.read_excel("429 Pythagorean Quadruples.xlsx", sheet_name="Sheet1", usecols="B", nrows=10) 

def find_quadr_solution(sides):
    sides = sides.replace("X", "0")

    numbers = np.array([float(num) for num in sides.split(", ") if num != 'NA'])
    numbers = numbers[numbers != 0]
    
    # Calculate missing side assuming d is missing
    missing1 = np.sqrt(np.sum(numbers**2))
    
    # Calculate missing side assuming a, b, or c is missing
    pot_d = np.max(numbers)
    others = numbers[numbers != pot_d]
    missing2 = np.sqrt(pot_d**2 - np.sum(others**2))
    
    if missing1 == np.floor(missing1):
        missing = missing1
    elif missing2 == np.floor(missing2):
        missing = missing2
    else:
        missing = np.nan 

    missing = np.int64(missing)
    return missing 

result = input.copy()
result["r"] = result["Number"].apply(find_quadr_solution)

print(result["r"].equals(test["Answer Expected"])) # True
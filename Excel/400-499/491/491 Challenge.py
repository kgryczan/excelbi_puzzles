import pandas as pd
import numpy as np

path = '491 Draw A Hollow Half Pyramid.xlsx'

test5 = pd.read_excel(path, skiprows=1, usecols='C:G', nrows=5, header=None).astype(float).reset_index(drop=True)
test5[test5 == 0] = np.nan

test8 = pd.read_excel(path, skiprows=8, usecols='C:J', nrows=8, header=None).astype(float).reset_index(drop=True)
test8[test8 == 0] = np.nan

def hollow_half_pyramid(input):
    matrix = np.full((input, input), np.nan)
    for i in range(input):
        matrix[i, 0] = 1
        matrix[i, i] = i + 1
        matrix[input - 1, i] = i + 1
    df = pd.DataFrame(matrix)
    df.columns = df.columns + 2
    return df

print(hollow_half_pyramid(8).equals(test8)) # True
print(hollow_half_pyramid(5).equals(test5)) # True
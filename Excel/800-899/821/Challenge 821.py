import pandas as pd
import numpy as np

path = "800-899/821/821 Pascal Triangle Variation.xlsx"
input_signs = pd.read_excel(path, usecols="B", skiprows=1, nrows=9, header=None).values.flatten()
test = pd.read_excel(path, usecols="E:U", skiprows=1, nrows=9, header=None).values

def generate_custom_pascal(signs):
    n = len(signs)
    triangle = np.full((n, 2 * n - 1), np.nan)
    triangle[0, n - 1] = 1

    for i in range(1, n):
        for j in range(n - i - 1, n + i):
            left = 0 if j - 1 < 0 else triangle[i - 1, j - 1]
            right = 0 if j + 1 > (2 * n - 2) else triangle[i - 1, j + 1]
            
            if np.isnan(left) and np.isnan(right):
                triangle[i, j] = np.nan
            else:
                left = 0 if np.isnan(left) else left
                right = 0 if np.isnan(right) else right
                if signs[i] == "+":
                    triangle[i, j] = left + right
                elif signs[i] == "*":
                    left = 1 if left == 0 else left
                    right = 1 if right == 0 else right
                    triangle[i, j] = left * right
    return triangle


result = generate_custom_pascal(input_signs)
print(np.array_equal(result, test, equal_nan=True)) # Truessssssssssssss
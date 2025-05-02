import pandas as pd
import numpy as np

path = "662 Create a Pyramid.xlsx"
test6 = pd.read_excel(path,  usecols="C:N", skiprows=1, nrows=6, header=None).fillna(" ").values

def draw_pyramid(stores):
    M = np.full((stores, stores * 2), " ", dtype=str)
    for i in range(1, stores + 1):
        row = [" "] * (stores - i) + ["/"] + ["/\\"] * (i - 1) + ["\\"] + [" "] * (stores - i)
        M[i - 1, :] = list("".join(row))
    return M

a = draw_pyramid(6)

print(np.array_equal(a, test6))
# True

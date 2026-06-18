import pandas as pd
import numpy as np

path = "1000-1099/1002/1002 Symmetric Triangles.xlsx"
input1 = 5
input2 = 12
test1 = (
    pd.read_excel(path, usecols="A:C", skiprows=1, nrows=input1, header=None)
    .fillna("")
    .to_numpy()
)
test2 = (
    pd.read_excel(path, usecols="A:F", skiprows=8, nrows=input2, header=None)
    .fillna("")
    .to_numpy()
)


def generate_symmetric_triangle(rows):
    max_cols = (rows + 1) // 2 if rows % 2 else rows // 2
    triangle = np.full((rows, max_cols), "", dtype=object)
    current = 0
    for row in range(rows):
        if row < rows / 2:
            length = row + 1
        else:
            length = rows - row
        for col in range(length):
            triangle[row, col] = chr(ord("A") + (current % 26))
            current += 1
    return triangle


print((generate_symmetric_triangle(input1) == test1).all())  # True
print((generate_symmetric_triangle(input2) == test2).all())  # True

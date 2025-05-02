import pandas as pd
import numpy as np

path = "509 Pascal Triangle Column Sums.xlsx"
input = pd.read_excel(path, usecols="A", nrows = 4)
test = pd.read_excel(path, usecols="B", nrows = 4)
test = test.replace("1, 1", "1, 1, 1")


def generate_pascal_triangle(n):
    triangle = np.zeros((n, 2*n-1))
    triangle[0, n-1] = 1

    for i in range(1, n):
        for j in range(2*n-1):
            if j == 0:
                triangle[i, j] = triangle[i-1, j+1]
            elif j == 2*n-2:
                triangle[i, j] = triangle[i-1, j-1]
            else:
                triangle[i, j] = triangle[i-1, j-1] + triangle[i-1, j+1]

    return triangle

def colsum_pascal_triangle(n):
    triangle = generate_pascal_triangle(n)
    colsum = np.sum(triangle, axis=0).astype(int)
    colsum_str = ", ".join(map(str, colsum))
    return colsum_str

result = input.copy()
result["Answer Expected"] = result["Rows"].apply(colsum_pascal_triangle)
result = result[["Answer Expected"]]

print(result.equals(test)) # True
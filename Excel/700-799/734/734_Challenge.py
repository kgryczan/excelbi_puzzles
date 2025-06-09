import pandas as pd
import numpy as np

path = "700-799/734/734 Number Spiral Grid.xlsx"
test = pd.read_excel(path, header=None, skiprows=1, nrows=8, usecols="A:H").to_numpy()

def generate_tidy_snake(n=8):
    r, c = np.indices((n, n)) + 1
    return np.where(
        r >= c,
        np.where(r % 2, (r - 1) ** 2 + c, r ** 2 - c + 1),
        np.where(c % 2, c ** 2 - r + 1, (c - 1) ** 2 + r)
    )

result = generate_tidy_snake(8)

print(np.array_equal(test, result))
import numpy as np
import string
import pandas as pd

path = "647 Alphabets Pattern Generation.xlsx"
test = pd.read_excel(path, header=None, usecols="A:AX", skiprows=1, nrows=26).fillna("")

def generate_matrix(rows=26, cols=50):
    mat = np.full((rows, cols), "", dtype=object)
    mat[:, 0] = "A"
    letters = np.array(list(string.ascii_uppercase))
    for i in range(1, cols):
        if (i + 1) % 2 == 0:
            start_row = (i + 1) // 2
            if start_row < rows:
                mat[start_row:, i] = letters[start_row:rows]
        else:
            start_row = (i + 2) // 2 + 1
            if start_row <= rows:
                mat[start_row-1:, i] = letters[start_row - 2]
    return mat

result = generate_matrix(26, 50)
df = pd.DataFrame(result)
print(df.equals(test)) # True

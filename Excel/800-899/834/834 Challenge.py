import pandas as pd
import numpy as np

path = "800-899/834/834 Group Rowwise.xlsx"
input = pd.read_excel(path, usecols="A:F", skiprows=1, nrows=9)
test = pd.read_excel(path, usecols="H:I", skiprows=1, nrows=4)
input_matrix = input.to_numpy()
result = pd.DataFrame({
    "Group": ["".join([str(x) for x in row if pd.notna(x)]) for row in input_matrix[::2]],
    "Sum": [eval("+".join([str(x) for x in row if pd.notna(x)])) for row in input_matrix[1::2]]
})

print(result.equals(test))
# True
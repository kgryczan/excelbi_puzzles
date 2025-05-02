import pandas as pd 
import numpy as np

path = "536 Populate Grid for Rows and Columns.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows = 9)
test  = pd.read_excel(path, usecols="E:J", nrows = 5, skiprows=1)

# approach 1
output = input.groupby(['Row', 'Column'])['Value'].apply(lambda x: ', '.join(x)).reset_index()
output = output.pivot(index='Row', columns='Column', values='Value').reset_index()
output['5'] = np.NaN
test.columns = output.columns

print(output.equals(test)) # True

# approach 2 
matrix = np.empty((5,5), dtype=object)
for i, row in input.iterrows():
    matrix[row['Row']-1, row['Column']-1] = row['Value'] if pd.isna(matrix[row['Row']-1, row['Column']-1]) else f"{matrix[row['Row']-1, row['Column']-1]}, {row['Value']}"
mat_test = test.iloc[:, 1:].values

matrix = matrix.fill(np.NaN)
mat_test = mat_test.fill(np.NaN)


print(np.array_equal(matrix, mat_test)) # True
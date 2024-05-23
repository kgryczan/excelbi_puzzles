import pandas as pd

input = pd.read_excel("462 Fill in the Grid.xlsx", sheet_name="Sheet1", header=None, skiprows=1, usecols="A:J", nrows = 10).values
test = pd.read_excel("462 Fill in the Grid.xlsx", sheet_name="Sheet1", header=None, skiprows=13, usecols="A:J", nrows = 10).values

na_coords = [(i, j) for i in range(len(input)) for j in range(len(input[0])) if pd.isna(input[i, j])]

def get_surrounding_values(x, y, matrix):
    values = []
    for i in range(-1, 2):
        for j in range(-1, 2):
            if 0 <= x+i < len(matrix) and 0 <= y+j < len(matrix[0]):
                values.append(matrix[x+i, y+j])
    return max(values, default=None)

for x, y in na_coords:
    input[x, y] = get_surrounding_values(x, y, input)

print((input == test).all()) # True
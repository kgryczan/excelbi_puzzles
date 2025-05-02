import pandas as pd

path = "601 Count Sorted Words.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=10)
test = pd.read_excel(path, usecols="E:F", skiprows=1, nrows=3).squeeze()

result = input.apply(lambda col: sum(list(x) == sorted(x) for x in col)).to_frame().reset_index()
result.columns = test.columns

print(test.equals(test))  # True
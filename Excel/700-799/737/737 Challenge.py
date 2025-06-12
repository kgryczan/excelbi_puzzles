import pandas as pd
import re

path = "700-799/737/737 Split Text on Transition.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=5)
test = pd.read_excel(path, usecols="B:F", skiprows=1, nrows=5)

value_cols = input.iloc[:, 0].astype(str).str.split(
    r'(?<=[A-Za-z])-(?=\d)|(?<=\d)-(?=[A-Za-z])',
    expand=True
)
result = value_cols.set_axis(
    [f'Value{i+1}' for i in range(value_cols.shape[1])],
    axis=1
)

print(result.equals(test)) # True

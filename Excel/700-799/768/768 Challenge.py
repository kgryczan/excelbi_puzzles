import pandas as pd

path = "700-799/768/768 Cumulative Total Positive and Negative.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=18)
test = pd.read_excel(path, usecols="B:C", skiprows=1, nrows=18)

input[['Positive', 'Negative']] = input['Numbers'].cumsum().apply(lambda x: pd.Series([x if x > 0 else None, x if x < 0 else None]))
input = input.drop(columns=['Numbers'])

print(input.equals(test)) # True
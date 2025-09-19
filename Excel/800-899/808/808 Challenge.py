import pandas as pd

path = "800-899/808/808 Group By Fruits.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=16, names=["Data"])
test = pd.read_excel(path, usecols="C:D", skiprows=1, nrows=6)

input = input.dropna()['Data'].str.split(', ', expand=True).stack().reset_index(drop=True)
fruits = input[~input.str.isdigit()].reset_index(drop=True)
weights = input[input.str.isdigit()].astype(int).reset_index(drop=True)
result = pd.DataFrame({'Fruits': fruits, 'Weight': weights})
result = result.groupby('Fruits', as_index=False)['Weight'].sum().rename(columns={'Weight': 'Total Weight'}).sort_values('Fruits').reset_index(drop=True)

print(result.equals(test)) # True
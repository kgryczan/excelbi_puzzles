import pandas as pd

path = "563 Bands of Numbers.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=16)
test = pd.read_excel(path, usecols="D:F", skiprows=1, nrows=4)\
    .rename(columns=lambda x: x.replace('.1', ''))

result = input.copy()
result['Group'] = result.groupby('Product')['Numbers'].diff().ne(1).cumsum()
result['Bands'] = result.groupby(['Group', 'Product'])['Numbers']\
    .transform(lambda x: f"{x.min()}-{x.max()}" if x.count() > 1 else x).astype(str)

result = result.groupby('Product').agg(
    Band=('Bands', lambda x: ', '.join(x.unique())),
    Count=('Bands', 'nunique')
).reset_index()

print(result.equals(test))  # True

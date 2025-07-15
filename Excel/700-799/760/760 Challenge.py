import pandas as pd

path = "700-799/760/760 Pivot.xlsx"

input = pd.read_excel(path, sheet_name=0, usecols="A:E", nrows=18, names=["C1", "C2", "C3", "C4", "C5"])
test = pd.read_excel(path, sheet_name=0, usecols="G:H", skiprows=1, nrows=5)

labels = input.iloc[::2].melt(value_name='label')['label']
values = input.iloc[1::2].melt(value_name='value')['value']
result = pd.DataFrame(list(zip(labels, values)), columns=['Value', 'Total']) \
    .groupby('Value', as_index=False)['Total'].sum()

print(result)
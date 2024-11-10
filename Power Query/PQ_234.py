import pandas as pd

path = "PQ_Challenge_234.xlsx"
input = pd.read_excel(path, usecols="A:G", nrows=5)
test = pd.read_excel(path, usecols="A:B", skiprows=9, nrows=5)

input_long = input.melt(id_vars=['Employee'], var_name='variable', value_name='value')
input_long[['variable', 'number']] = input_long['variable'].str.extract(r'(\D+)(\d+)')
input_long = input_long.dropna().pivot(index=['Employee', 'number'], columns='variable', values='value').reset_index()
input_long = input_long.assign(seq=input_long.apply(lambda row: pd.date_range(start=row['StartDate'], end=row['EndDate']), axis=1))\
    .explode('seq').reset_index(drop=True)
input_long = input_long[input_long['seq'].dt.weekday < 5]

result = input_long.groupby('Employee').agg(TotalLeaves=('seq', 'nunique')).reset_index()

print(result.equals(test)) # True

import pandas as pd

path = "300-399/331/PQ_Challenge_331.xlsx"
input1 = pd.read_excel(path, usecols="A:H", nrows=10)
input2 = pd.read_excel(path, usecols="J:K", nrows=8)
test   = pd.read_excel(path, usecols="A:C", skiprows=14, nrows=12)

input1_long = (
    input1.melt(id_vars=['Customer', 'Date'], var_name='col')
    .assign(set=lambda df: df['col'].str.extract(r'(\d+)')[0],
            type=lambda df: df['col'].str.extract(r'(Product|Units)')[0])
    .pivot(index=['Customer', 'Date', 'set'], columns='type', values='value')
    .reset_index()
)
result = (
    input1_long.merge(input2, left_on='Product', right_on='Fruits')
    .dropna(subset=['Product', 'Units', 'Price'])
    .assign(Units=lambda df: pd.to_numeric(df['Units']),
            Price=lambda df: pd.to_numeric(df['Price']),
            Amount=lambda df: (df['Units'] * df['Price']).astype(int))
    .groupby(['Customer', 'Product'], as_index=False)['Amount'].sum()
    .sort_values(['Customer', 'Product'])
    .reset_index(drop=True)
)

print(result.equals(test))
import pandas as pd

path = "700-799/772/772 Split and Sum.xlsx"
input = pd.read_excel(path, usecols="A", nrows=14, header=0)
test = pd.read_excel(path, usecols="B:C", skiprows=1, nrows=4, names=["Letter", "Value"])

split = (
    input['Data']
    .str.split('-', n=1, expand=True)
    .dropna()
    .set_axis(['Letter', 'Number'], axis=1)
    .assign(Number=lambda df: pd.to_numeric(df['Number'], errors='coerce'))
)
result = (
    split
    .groupby('Letter', as_index=False)['Number']
    .sum()
    .rename(columns={'Number': 'Value'})
)

comparison = result.equals(test)
# Mistake in given solution.

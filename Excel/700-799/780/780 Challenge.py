import pandas as pd

path = "700-799/780/780 Profit.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=9, skiprows=1)
test = pd.read_excel(path, usecols="F:I", nrows=4, skiprows=1).rename(columns={'Org.1': 'Org'}).astype({2011: float, 2012: float, 2013: float})

result = (
    input.ffill()
    .assign(Profit=lambda df: df['Revenue'] - df['Cost'])
    .pivot_table(index='Org', columns='Year', values='Profit', aggfunc='sum')
    .reset_index()[['Org', 2011, 2012, 2013]]
    .astype({2011: float, 2012: float, 2013: float})
)
result.columns.name = None

print(result.equals(test)) # True
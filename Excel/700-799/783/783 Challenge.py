import pandas as pd

path = "700-799/783/783 Top 3 by Revenue.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=30)
test = pd.read_excel(path, usecols="D:E", skiprows=1, nrows=4).rename(columns=lambda c: c.replace('.1', ''))

revenue_sum = input.groupby('Org', as_index=False)['Revenue'].sum()
result = (
    revenue_sum[
        revenue_sum['Revenue'] >= revenue_sum['Revenue'].nlargest(3).min()
    ]
    .sort_values('Revenue', ascending=False)
    .reset_index(drop=True)
)

print(result.equals(test)) # True
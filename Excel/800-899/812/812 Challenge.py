import pandas as pd

path = "800-899/812/812 Generate Pivot Table.xlsx"
df = pd.read_excel(path, usecols="A:B", nrows=100)
test = pd.read_excel(path, usecols="D:F", skiprows=1, nrows=8)

bins = [1990,1995,2000,2005,2010,2015,2020,2025]
labels = [f"{y}-{y+4}" for y in range(1990,2020,5)] + ["2020-2024"]
df['Year'] = pd.cut(df['Year'], bins=bins, labels=labels, right=False).astype(str).fillna(df['Year'].astype(str))
result = df.groupby('Year', as_index=False)['Value'].sum().rename(columns={'Value':'Total'})
result['Running'] = result['Total'].cumsum() / result['Total'].sum()

grand_total = pd.DataFrame([{'Year': 'Grand Total', 'Total': result['Total'].sum(), 'Running': 1.000}])
result = pd.concat([result, grand_total], ignore_index=True)
result.columns = test.columns

print(result.equals(test)) # True
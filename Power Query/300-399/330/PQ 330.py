import pandas as pd

path = "300-399/330/PQ_Challenge_330.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=35)
test = pd.read_excel(path, usecols="D:F", nrows=11)

input['Year'] = input['Data2'].where(input['Data1'] == 'Year').ffill()
mask = (~input['Data1'].str.contains("Year|TOTAL|Continent", na=False) & pd.to_numeric(input['Data2'], errors='coerce').gt(0))
result = input.loc[mask, ['Data1', 'Year', 'Data2']].rename(columns={'Data1': 'Continent', 'Data2': 'Sales'}).reset_index(drop=True)
result[['Year', 'Sales']] = result[['Year', 'Sales']].astype(int)

print(result.equals(test))

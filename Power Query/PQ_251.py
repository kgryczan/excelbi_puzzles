import pandas as pd

path = "PQ_Challenge_251.xlsx"
input = pd.read_excel(path, sheet_name=0, usecols="A:E", nrows=21)
test = pd.read_excel(path, sheet_name=0, usecols="G:O", nrows=5).rename(columns=lambda x: x.split('.')[0])\
    .sort_values("Emp ID").reset_index(drop=True)

input_long = pd.concat([
    input[['Emp ID', 'Attribute1', 'Value1']].rename(columns={'Attribute1': 'Attr', 'Value1': 'Val'}),
    input[['Emp ID', 'Attribute2', 'Value2']].rename(columns={'Attribute2': 'Attr', 'Value2': 'Val'})
])

input_long = input_long.dropna()
result = input_long.pivot(index='Emp ID', columns='Attr', values='Val').reset_index()
result[['First Name', 'Last Name']] = result['Full Name'].str.split(' ', expand=True)
result = result[['Emp ID', 'First Name', 'Last Name', 'Gender', 'Date of Birth', 'Weight', 'Salary', 'State', 'Sales']]
result[['Weight', 'Salary', 'Sales']] = result[['Weight', 'Salary', 'Sales']].apply(pd.to_numeric)
result['Date of Birth'] = pd.to_datetime(result['Date of Birth'], errors='coerce')
result = result.sort_values(by = 'Emp ID').reset_index(drop=True)
result.index.name = None

print(result.equals(test)) # True
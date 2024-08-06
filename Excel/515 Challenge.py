import pandas as pd

path = "515 Normalization of Data.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows = 1, nrows = 5)
test  = pd.read_excel(path, usecols="D:F", skiprows = 1)
test.columns = test.columns.str.replace('.1', '')

result = input.copy()
result['Data'] = result['Data'].str.split('\n')
result = result.explode('Data')
result[['Name', 'Seq']] = result['Data'].str.split(' :', expand=True)
result = result.drop(columns=['Data'])
result['Name'] = result['Name'].str.strip()
result['Seq'] = result['Seq'].str.strip().str.split(', ')
result = result.explode('Seq')
result["Seq"] = result["Seq"].astype("int64")
result = result[["Seq", "Name", "State"]].sort_values(by=['Seq']).reset_index(drop=True)

print(result.equals(test)) # True
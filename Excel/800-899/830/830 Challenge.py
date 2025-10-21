import pandas as pd

path = "800-899/830/830 Transpose.xlsx"

input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=18)
test = pd.read_excel(path, usecols="D:F", skiprows=1, nrows=5)

input['type'] = input['Data2'].where(input['Data1'] == 'Type').ffill()
input['Student'] = input['Data2'].where(input['Data1'] == 'Student').ffill()
filtered = input[~input['Data2'].isin(input['type'].dropna().tolist() + input['Student'].dropna().tolist())]
result = filtered.pivot(index='Student', columns='Data1', values='Data2').reset_index()
result['Marks'] = pd.to_numeric(result['Marks'])
result = result.sort_values(['Marks', 'Student'], ascending=[False, True]).reset_index(drop=True)

print(result.equals(test)) # True
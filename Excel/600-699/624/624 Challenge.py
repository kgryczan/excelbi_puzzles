import pandas as pd

path = "624 Top 3 Highest Sales.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=20)
test = pd.read_excel(path, usecols="E:G", nrows=4).rename(columns=lambda x: x.split('.')[0])

summary = input.groupby(['Customer', 'Date'], as_index=False)['Amount'].sum()
summary['Rank'] = summary['Amount'].rank(method='dense', ascending=False)
result = summary[summary['Rank'] <= 3].sort_values(by=['Amount', 'Date'], ascending=[False, True]).drop(columns='Rank').reset_index(drop = True)
result = result.rename(columns={'Customer': 'Name'})

print(result.equals(test)) # True
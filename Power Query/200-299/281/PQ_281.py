import pandas as pd

path = "PQ_Challenge_281.xlsx"
input = pd.read_excel(path, usecols="A", nrows=8)
test = pd.read_excel(path, usecols="C:D", nrows=10)

result = input.assign(Data=input['Data'].str.split(',')).explode('Data')
result[['Capital', 'State']] = result['Data'].str.split(r' \(C\) - ', expand=True)
result = result.drop(columns=['Data']).sort_values(by=['State'])
result = result[["State", "Capital"]].reset_index(drop=True)
result = result.dropna()


print(result)
print(test)
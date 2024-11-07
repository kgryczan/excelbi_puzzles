import pandas as pd

path = "582 Pivot on Min and Max_2.xlsx"
input = pd.read_excel(path,  usecols="A:C", nrows=26)
test = pd.read_excel(path,  usecols="E:G", nrows=6).rename(columns=lambda x: x.split('.')[0])
test['Emp ID'] = test['Emp ID'].astype(str)

result = input.groupby(['Date', 'Time']).agg({'Emp ID': lambda x: ', '.join(sorted(map(str, x)))}).reset_index()
min_max_time = input.groupby('Date')['Time'].agg(['min', 'max']).reset_index()
result = result.merge(min_max_time, on='Date')
result = result[result['Time'].isin(result[['min', 'max']].values.flatten())]
result = result.drop(columns=['min', 'max']).sort_values(by=['Date', 'Time']).reset_index(drop=True)
result['Emp ID'] = result['Emp ID'].astype(str)

print(result.equals(test)) # True
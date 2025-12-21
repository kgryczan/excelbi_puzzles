import pandas as pd

path = "Power Query/300-399/350/PQ_Challenge_350.xlsx"
input_df = pd.read_excel(path, sheet_name=0, usecols="A:I", nrows=121)
input2 = pd.read_excel(path, usecols="K", skiprows=1, nrows=1, header=None).iloc[0, 0]
input3 = pd.read_excel(path, usecols="K", skiprows=3, nrows=1, header=None).iloc[0, 0]
test = pd.read_excel(path, usecols="M:V", nrows=7).fillna(0)

result = input_df.rename(columns={'Material code': 'Mat Code','Material name': 'Mat Name'})[['Mat Code','Mat Name','Day','Weight Net']]
result = result[(result['Day'] >= input2) & (result['Day'] <= input3)]
result['weight'] = result['Weight Net'] / 1000
result = result.drop(columns='Weight Net').pivot_table(index=['Mat Code','Mat Name'],columns='Day',values='weight',aggfunc='sum',fill_value=0).reset_index()
result['Grand Total'] = result.iloc[:,2:].sum(1)
result = result.set_index(result.columns[0]).loc[test.iloc[:,0]].reset_index().round(2)
test = test.round(2)

print(result.equals(test)) # True


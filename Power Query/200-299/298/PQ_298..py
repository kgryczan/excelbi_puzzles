import pandas as pd

path = "200-299/298/PQ_Challenge_298.xlsx"
input = pd.read_excel(path, usecols="A:E", nrows=5)
test = pd.read_excel(path, usecols="G:I", nrows=15)

in1 = input.iloc[:, [0,1,2]].copy()
in1.columns = ['Company', 'Subtype', 'Price']
in1['Type'] = 'Software'

in2 = input.iloc[:, [0,3,4]].copy()
in2.columns = ['Company', 'Subtype', 'Price']
in2['Type'] = 'Hardware'

result = pd.concat([in1, in2], ignore_index=True)
result = result[result['Subtype'].notna()]
result['Order'] = range(1, len(result)+1)
result = result.melt(id_vars=['Company','Order'], var_name='Classification', value_name='Value')
result = result.sort_values(['Company', 'Order', 'Classification'], ascending=[False, True, False])
result['Classification'] = result['Classification'].replace({'Subtype': 'Sub type'})
result['cclass'] = result.groupby(['Company','Value']).cumcount()+1
result = result[(result['cclass']==1) & (result['Value'].notna())]
result = result.drop(['Order','cclass'], axis=1).reset_index(drop=True)

print(result.equals(test))
#> [1] True
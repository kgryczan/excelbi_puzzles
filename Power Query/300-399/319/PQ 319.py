import pandas as pd

path = "300-399/319/PQ_Challenge_319.xlsx"
input = pd.read_excel(path, sheet_name=1, usecols="A:I", nrows=4)
test = pd.read_excel(path, sheet_name=1, usecols="A:F", skiprows=8, nrows=10)

input_long = input.melt(id_vars='Fruits', var_name='Q_value')
input_long[['Q', 'Type']] = input_long['Q_value'].str.split('-', expand=True)
input_wide = input_long.pivot(index=['Fruits', 'Q'], columns='Type', values='value').reset_index()
input_wide[['Price', 'Quantity']] = input_wide[['Price', 'Quantity']].apply(pd.to_numeric)
input_wide['Total'] = input_wide['Price'] * input_wide['Quantity']
result_long = input_wide.melt(id_vars=['Fruits', 'Q'], value_vars=['Price', 'Quantity', 'Total'],
                              var_name='Quarters', value_name='Values')
result = result_long.pivot(index=['Fruits', 'Quarters'], columns='Q', values='Values').reset_index()
result['Fruits'] = result.groupby('Fruits')['Fruits'].transform(lambda x: [x.iloc[0]] + [None]*(len(x)-1))

print(result.equals(test)) # True
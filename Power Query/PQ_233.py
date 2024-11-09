import pandas as pd

path = "PQ_Challenge_233.xlsx"
input = pd.read_excel(path, usecols="A:G", nrows=7)
test = pd.read_excel(path, usecols="A:H", skiprows=12, nrows=4)

input_long = input.melt(id_vars=['Fruits'], var_name='variable', value_name='value')
input_long[['Type', 'number']] = input_long['variable'].str.extract(r'([A-Za-z]+)(\d)')
input_long = input_long.pivot(index=['Fruits', 'number'], columns='Type', values='value').reset_index()

input_long['amount'] = input_long['Price'] * input_long['Quantity']
result = input_long.groupby(['Fruits', 'Shipped'], as_index=False).agg(amount=('amount', 'sum'))
result['Status'] = result['Shipped'].replace({'Y': 'Shipped Amount', 'N': 'Not Shipped Amount'})

result_pivot = result.pivot_table(index='Status', columns='Fruits', values='amount', aggfunc="sum", fill_value=0, margins=True, margins_name='Total').reset_index()
result_pivot = result_pivot[result_pivot['Status'] != 'Total'].sort_values(by='Status', ascending=False)\
        ._append(result_pivot[result_pivot['Status'] == 'Total'], ignore_index=True)

result_pivot = result_pivot[['Status', 'Apple', 'Banana', 'Papaya', "Mango", "Pineapple", "Kiwi", 'Total']]
result_pivot.columns.name = None

print(all(result_pivot == test))  # True

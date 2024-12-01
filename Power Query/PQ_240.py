import pandas as pd

path = "PQ_Challenge_240.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=8)
test = pd.read_excel(path, usecols="E:J", nrows=8)

input = input.assign(Items=input['Items'].str.split(', ')).explode('Items')
input[['Item', 'Quantity']] = input.pop('Items').str.split(': ', expand=True)
input['Quantity'] = pd.to_numeric(input['Quantity'])
result = input.pivot_table(index=['Supplier', 'Date'], columns='Item', values='Quantity', fill_value=0).reset_index()
result = result[['Supplier', 'Date', 'Bread', 'Coke', 'Milk', 'Rice']].sort_values(by=['Supplier', 'Date'], ascending=[True, False])

# Almost equal. Misgtake in source file.
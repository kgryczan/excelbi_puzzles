import pandas as pd

path = "682 Aggregation at Order No Level.xlsx"

input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=9)
test = pd.read_excel(path, usecols="E:G", skiprows=1, nrows=14).rename(columns=lambda col: col.replace('.1', ''))

input = input.assign(Order_No=input['Order No'].str.split(', ')).explode('Order_No')
result = (input.assign(Amount_pc=input['Amount'] / input.groupby('Name')['Amount'].transform('size'))
         .groupby('Order_No', as_index=False)
         .agg(Names=('Name', lambda x: ', '.join(sorted(set(x)))), Amount=('Amount_pc', 'sum'))
         .sort_values('Order_No')
         .astype({'Order_No': 'int64', 'Amount': 'int64'}))

# Almost equal one field has different sorting of names

import pandas as pd

path = "PQ_Challenge_231.xlsx"
input1 = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=3)
input2 = pd.read_excel(path, usecols="A:B", skiprows=7, nrows=8)
test = pd.read_excel(path, usecols="E:J", skiprows=1, nrows=4)

input1 = input1.assign(
    Items=input1['Items'].str.split(', '),
    Quantity=input1['Quantity'].str.split(', ')
).explode(['Items', 'Quantity'], ignore_index=True)

input = input1.merge(input2, on='Items', how='left')
input['Amount'] = input.eval('Quantity.astype("int64") * Price').astype('int64')
input.drop(columns=['Price', 'Quantity'], inplace=True)

input = input.pivot_table(
    index='Person', 
    columns='Items', 
    values='Amount', 
    aggfunc='sum', 
    fill_value=0, 
    margins=True, 
    margins_name='Total'
).reset_index().rename(
    columns={'Person': 'Name'}
).rename_axis(
    None, axis=1
)

print(input.equals(test))   # True

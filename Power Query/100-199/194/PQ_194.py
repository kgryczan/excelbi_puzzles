import pandas as pd

path = 'PQ Challenge_194.xlsx'
input = pd.read_excel(path, usecols = "A:D")
test  = pd.read_excel(path, usecols = "F:I") 
test.columns = input.columns

result = input.melt(id_vars=['Date'], var_name='Amt', value_name='Value') \
    .sort_values(['Date', 'Amt']).reset_index(drop = True) \
    .assign(val=lambda x: x['Value'].shift(fill_value=0),
            diff=lambda x: x['Value'] - x['val']) \
    .drop(columns=['Value', 'val']) \
    .pivot(index='Date', columns='Amt', values='diff').reset_index(drop=False) 

print(result.equals(test)) # True
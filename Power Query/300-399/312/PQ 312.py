import pandas as pd
import numpy as np

path = "300-399/312/PQ_Challenge_312.xlsx"
input = pd.read_excel(path, skiprows=0, nrows=11, usecols="A:M")
test = pd.read_excel(path, skiprows=14, nrows=7, usecols="A:H").sort_values(['State', 'Customer']).reset_index(drop=True)

cols = {'Category': ('Column1', 'Column2'), 'State': ('Column3', 'Column4'), 'Year': ('Column5', 'Column6')}
for k, (col, val) in cols.items():
    input[k] = np.where(input[col] == k, input[val], np.nan)
input[['Category', 'State', 'Year']] = input[['Category', 'State', 'Year']].ffill()

input = input[input['Column1'] != "Category"].copy()

input.columns = input.iloc[0]
input = input[1:].reset_index(drop=True)
input.columns.name = None
input = input.rename(columns={
    'Months': 'Customer',
    'Home Loan': 'Category',
    'Alabama': 'State',
    2023: 'Year'
})

df_long = input.melt(
    id_vars=['Category', 'State', 'Year', 'Customer'],
    var_name='Month',
    value_name='Amount'
)

df_long['Amount'] = pd.to_numeric(df_long['Amount'], errors='coerce').astype('Int64')
df_long['Year'] = pd.to_numeric(df_long['Year'], errors='coerce')
df_long = df_long[df_long['Customer'] != 'Months']

df_long['quarter'] = df_long['Month'].map({
    m: f"Q{(i//3)+1}" for i, m in enumerate(
        ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    )
})

result = df_long.pivot_table(
    index=['Category', 'State', 'Year', 'Customer'],
    columns='quarter',
    values='Amount',
    aggfunc='sum'
).reset_index()

result.columns.name = None
result = result.sort_values(by=['State', 'Customer'], ascending=[True, True]).reset_index(drop=True)

print((test==result).all().all()) # True
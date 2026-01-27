import pandas as pd
import numpy as np

path = "Excel/900-999/900/900 Sales Larger than Quarterly Average.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=50)
test = pd.read_excel(path, usecols="E:F", skiprows=1, nrows=6)

input['Date'] = pd.to_datetime(input['Date'])
input['quarter'] = input['Date'].dt.quarter
input['Month'] = pd.Categorical(input['Date'].dt.month_name().str[:3], 
    categories=['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'], ordered=True)
input['quarterly_avg'] = input.groupby('quarter')['Sales'].transform('mean')
input['valid'] = (input['Sales'] > input['quarterly_avg']).astype(int)

summary = input.groupby(['Month', 'Salesperson'], observed=True, as_index=False).agg(
    spvalid=('valid', lambda x: x.sum() == len(x)))
filtered = summary[summary['spvalid']]
names_summary = filtered.groupby('Month', observed=True).agg(
    Names=('Salesperson', ', '.join)).reindex(
    ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
).reset_index().head(6)

print(names_summary.equals(test))
# True
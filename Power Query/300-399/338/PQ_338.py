import pandas as pd
import numpy as np

path = "Power Query/300-399/338/PQ_Challenge_338.xlsx"
input = pd.read_excel(path, usecols="A:F", nrows=17)
test = pd.read_excel(path, usecols="H:L", nrows=21)

input['store'] = np.where(input['Column1'].str.contains("Store", na=False), input['Column1'], np.nan)
input['store'] = input['store'].ffill()

m1 = (
    input[input['Column2'].isin(['M', 'F'])]
    .rename(columns={'Column2': 'gender', 'Column3': 'Q1', 'Column4': 'Q2', 'Column5': 'Q3', 'Column6': 'Q4'})
    .melt(id_vars=['store', 'gender'], value_vars=['Q1', 'Q2', 'Q3', 'Q4'], var_name='Quarter', value_name='Sales')
    .groupby(['store', 'Quarter'], as_index=False)
    .agg({'Sales': lambda x: pd.to_numeric(x, errors='coerce').sum()})
    .rename(columns={'store': 'Store', 'Sales': 'Total Employees'})
)

non_emp = input[~input['Column2'].isin(['M', 'F'])].copy()
non_emp['Column1'] = non_emp['Column1'].ffill()
non_emp = non_emp[~non_emp['Column1'].str.contains("Store", na=False)]

m2 = (
    non_emp.rename(columns={'Column1': 'Item', 'Column2': 'Measure', 'Column3': 'Q1', 'Column4': 'Q2', 'Column5': 'Q3', 'Column6': 'Q4'})
    .melt(id_vars=['store', 'Item', 'Measure'], value_vars=['Q1', 'Q2', 'Q3', 'Q4'], var_name='Quarter', value_name='Value')
    .pivot(index=['store', 'Item', 'Quarter'], columns='Measure', values='Value')
    .reset_index()
)
m2['Amount'] = pd.to_numeric(m2['Quantity'], errors='coerce') * pd.to_numeric(m2['Price'], errors='coerce')
m2 = m2.rename(columns={'store': 'Store'})

final = (
    m1.merge(m2[['Store', 'Item', 'Quarter', 'Amount']], on=['Store', 'Quarter'], how='left')
    .loc[:, ['Store', 'Quarter', 'Total Employees', 'Item', 'Amount']]
    .sort_values(['Store', 'Item', 'Quarter'])
    .reset_index(drop=True)
)
print(final.equals(test))
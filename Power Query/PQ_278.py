import pandas as pd
import numpy as np
from datetime import datetime

path = "PQ_Challenge_278.xlsx"

input_data = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="C:I", nrows=4).fillna(0)
test = test.apply(lambda col: col.astype('int64') if col.dtypes == 'float64' else col)
input_data[['Date', 'Org', 'Revenue', 'Cost']] = input_data.iloc[:, 0].str.split(' - ', expand=True)
input_data['profit'] = pd.to_numeric(input_data['Revenue'], errors='coerce').fillna(0) - pd.to_numeric(input_data['Cost'], errors='coerce').fillna(0)
input_data['month'] = pd.to_datetime(input_data['Date'], errors='coerce').dt.strftime('%b').astype(pd.CategoricalDtype(categories=["Jan", "Feb", "Mar", "Apr", "May", "Jun"], ordered=True))
input_data.drop(columns=[input_data.columns[0], 'Revenue', 'Cost', 'Date'], inplace=True)

result = input_data.pivot_table(
    index='Org', columns='month', values='profit', aggfunc='sum', fill_value=0
).reset_index()

total_row = pd.DataFrame([{
    'Org': 'Total',
    **{month: result[month].sum() for month in ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]}
}])
res = pd.concat([result, total_row], ignore_index=True).fillna(0)


print(res.equals(test))
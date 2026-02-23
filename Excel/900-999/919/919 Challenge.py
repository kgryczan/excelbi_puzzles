import pandas as pd
import numpy as np

path = "Excel/900-999/919/919 Low High.xlsx"

input = pd.read_excel(path, usecols="A:B", nrows=262)
test = pd.read_excel(path, usecols="C", nrows=262).fillna({"Answer Expected": ""})

input['quarter'] = pd.to_datetime(input['Date']).dt.quarter
input['month'] = pd.to_datetime(input['Date']).dt.month
input['yearly'] = input['Price'].apply(
    lambda x: "Yearly High" if x == input['Price'].max() else ("Yearly Low" if x == input['Price'].min() else np.nan)
)
input['quarterly'] = input.groupby('quarter')['Price'].transform(
    lambda x: x.apply(lambda y: "Quarterly High" if y == x.max() else ("Quarterly Low" if y == x.min() else np.nan))
)
input['monthly'] = input.groupby('month')['Price'].transform(
    lambda x: x.apply(lambda y: "Monthly High" if y == x.max() else ("Monthly Low" if y == x.min() else np.nan))
)
input['result'] = input[['yearly', 'quarterly', 'monthly']].apply(
    lambda row: ", ".join(row.dropna()), axis=1
)
input = input.drop(columns=['quarter', 'month', 'yearly', 'quarterly', 'monthly'])

print(input['result'].equals(test['Answer Expected']))
# one row incorrect in original. 
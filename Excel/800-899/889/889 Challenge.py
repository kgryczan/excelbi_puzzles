import pandas as pd
import numpy as np

path = "Excel/800-899/889/889 CYTD Commission Calculation.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=21)
test = pd.read_excel(path, usecols="D", nrows=21)

input['Date'] = pd.to_datetime(input['Date'])
input['year'] = input['Date'].dt.year
input['CumsumSales'] = input.groupby(['Sales_Rep', 'year'])['Sale_Amount'].cumsum()
input['cum_comm'] = (
    np.minimum(input['CumsumSales'], 10000) * 0.05 +
    np.maximum(np.minimum(input['CumsumSales'] - 10000, 10000), 0) * 0.10 +
    np.maximum(input['CumsumSales'] - 20000, 0) * 0.15
)
input['tier_comm'] = input.groupby(['Sales_Rep', 'year'])['cum_comm'].diff().fillna(input['cum_comm']).astype('int64')

print(input['tier_comm'].equals(test['Answer Expected'])) # True
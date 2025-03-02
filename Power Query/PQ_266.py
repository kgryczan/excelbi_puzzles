import pandas as pd
import numpy as np

path = "PQ_Challenge_266.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=20)
test = pd.read_excel(path, usecols="E:I", nrows=17).rename(columns=lambda col: col.split('.')[0])

R1 = input.groupby(['Sales Person', 'Item']).agg(
    Total_Orders=('Date', 'count'),
    First_Order_Date=('Date', 'min'),
    Last_Order_Date=('Date', 'max')
).reset_index()

R2 = input.groupby('Sales Person').agg(
    Total_Orders=('Date', 'count'),
    First_Order_Date=('Date', 'min'),
    Last_Order_Date=('Date', 'max')
).reset_index()
R2['Item'] = np.NaN
R2['Sales Person'] = R2['Sales Person'] + " Total"

result = pd.concat([R1, R2]).sort_values(by=['Sales Person', 'Item']).reset_index(drop=True)
result = result[['Sales Person', 'Item', 'Total_Orders', 'First_Order_Date', 'Last_Order_Date']]
result.columns = result.columns.str.replace('_', ' ')

print(result.equals(test))  # True
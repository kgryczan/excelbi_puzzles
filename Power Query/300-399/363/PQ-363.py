import pandas as pd
import numpy as np
from numpy.testing import assert_almost_equal

path = "Power Query/300-399/363/PQ_Challenge_363.xlsx"

input1 = pd.read_excel(path, usecols="A:C", nrows=16)
input2 = pd.read_excel(path, usecols="E:G", nrows=11)
test = pd.read_excel(path, usecols="E:F", skiprows=15, nrows=11)

input2 = input2.assign(order_item=input2['Order String (Qty x Item)'].str.split(', ')).explode('order_item')
input2[['Qty', 'Item']] = input2['order_item'].str.split('x', expand=True)
input2['Qty'] = pd.to_numeric(input2['Qty'].str.strip())
input2['Item'] = input2['Item'].str.strip()
input2 = input2.merge(input1, on='Item', how='left')

input2['Total'] = np.select(
    [
        input2['Discount Code'] == "NONE",
        input2['Discount Code'] == "SAVE10",
        (input2['Discount Code'] == "BOGO-DRINK") & (input2['Category'] == "Drink")
    ],
    [
        input2['Price'] * input2['Qty'],
        input2['Price'] * input2['Qty'] * 0.9,
        input2['Price'] * ((input2['Qty'] + 1) // 2)
    ],
    default=input2['Price'] * input2['Qty']
)

res = input2.groupby('Order ID', as_index=False).agg({'Total': 'sum'}).rename(columns={'Total': 'Final Total'})

# Check if 'res' is almost equal to 'test'
try:
    assert_almost_equal(res['Final Total'].values, test['Final Total'].values, decimal=2)
    print("res is almost equal to test")
except AssertionError:
    print("res is not almost equal to test")



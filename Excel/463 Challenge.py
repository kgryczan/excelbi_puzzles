import pandas as pd
from itertools import accumulate

input = pd.read_excel("463 Inventory Calculation.xlsx", usecols="A:C", nrows = 6)
test = pd.read_excel("463 Inventory Calculation.xlsx", usecols="E:F", skiprows = 1, nrows = 13)

months = pd.DataFrame(
    {
        'abbs': ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
        'months': range(1, 13)
    }
)

result = months.merge(input, left_on='abbs', right_on='Month', how='left').fillna(0)
result['inventory'] = list(accumulate(result['Incoming Qty'] - result['Outgoing Qty'], initial=0))[1:]
result['inventory'] = result['inventory'].astype("int64")
result = result[['abbs','inventory']]
result.columns = test.columns

print(result.equals(test)) # True
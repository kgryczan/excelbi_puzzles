import pandas as pd
import numpy as np

path = "644 Total Cost.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=16)
test = pd.read_excel(path, usecols="D:E", skiprows=1, nrows=4).sort_values('Name').reset_index(drop  = True)

input['Name'] = input['Name & Category'].where(input['Cost'].isna()).ffill()
result = input.fillna({'Cost': 0}).groupby('Name')['Cost'].sum().reset_index().rename(columns={'Cost': 'Total Cost'})
result['Total Cost'] = result['Total Cost'].astype(np.int64)

print(result.equals(test)) # True
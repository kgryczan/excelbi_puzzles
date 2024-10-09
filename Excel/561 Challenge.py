import pandas as pd
import numpy as np

path = "561 Maximum Profit.xlsx"
input = pd.read_excel(path, usecols="A:J", skiprows=1, nrows=10)
test = pd.read_excel(path, usecols="K:M", skiprows=1, nrows=10)
test = test.map(lambda x: np.nan if x == "NP" else float(x))

def process_row(row):
    max_diff = -np.inf
    buy_value = np.nan
    sell_value = np.nan
    
    for i in range(len(row) - 1):
        for j in range(i + 1, len(row)):
            diff = row[j] - row[i]
            if diff > max_diff:
                max_diff = diff
                buy_value = row[i]
                sell_value = row[j]
    
    return pd.Series([buy_value, sell_value, max_diff])

result = input.apply(process_row, axis=1)
result.columns = ['Buy', 'Sell', 'Profit']
result['Buy'] = np.where(result['Profit'] <= 0, np.nan, result['Buy'])
result['Sell'] = np.where(result['Profit'] <= 0, np.nan, result['Sell'])
result['Profit'] = np.where(result['Profit'] <= 0, np.nan, result['Profit'])

print(result.equals(test)) # True

import pandas as pd

path = "PQ_Challenge_198.xlsx"

input = pd.read_excel(path, usecols="A:B")
test  = pd.read_excel(path, usecols="D:F")
test.columns = test.columns.str.replace('.1', '')

result = input.assign(month=input['Date'].dt.month) \
              .groupby('month') \
              .agg(Max=('Value', 'max')) \
              .assign(Running_Total=lambda x: x['Max'].cumsum()) \
              .merge(input.assign(month=input['Date'].dt.month), on='month', how='right') \
              .rename(columns={'Running_Total': 'Running Total'}) \
              .loc[:, ['Date', 'Value', 'Running Total']]

print(result.equals(test)) # True
import pandas as pd
import numpy as np

path = "200-299/291/PQ_Challenge_291.xlsx"
input = pd.read_excel(path, sheet_name=0, usecols="A:D", nrows=49)
test = pd.read_excel(path, sheet_name=0, usecols="F:I", nrows=28).rename(columns=lambda x: x.replace('.1', ''))

input[['Company', 'Target']] = input[['Company', 'Target']].ffill()
input['Cumulative Sales'] = input.groupby('Company')['Sales'].cumsum()
result = input[input['Cumulative Sales'] <= input['Target']].reset_index(drop=True)
result.loc[result.groupby('Company').cumcount() != 0, ['Company', 'Target']] = np.nan
result = result.drop(columns='Cumulative Sales')

print(result.equals(test))
# TRUE
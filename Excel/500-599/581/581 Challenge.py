import pandas as pd
import numpy as np

path = "581 Increment Sequences.xlsx"
input = pd.read_excel(path, usecols="A", nrows=18)
test = pd.read_excel(path, usecols="B", nrows=18)

input['Answer_Expected'] = np.where(
    input['Column1'].isna(), 
    0, 
    (input['Column1'].notna() & (input['Column1'] != input['Column1'].shift(1).fillna(''))).cumsum()
).astype('int64')

print(input['Answer_Expected'].equals(test['Answer Expected']))

print(input.dtypes)
print(test.dtypes)
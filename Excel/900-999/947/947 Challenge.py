import pandas as pd
from itertools import accumulate

path = "900-999/947/947 Block Number Within 8 Hours Constraint.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=11, skiprows=1)
test = pd.read_excel(path, usecols="D:F", nrows=11, skiprows=1).rename(columns=lambda c: c.rstrip(".1"))

hours = input['Hours'].tolist()
rem_cap = list(accumulate(hours, lambda rem, h: rem - h if rem >= h else 8 - h, initial=8))[1:]
prev_rem = [8] + rem_cap[:-1]
input['Block Number'] = 1 + (pd.Series(prev_rem) < input['Hours']).cumsum().values
input['Remaining Capacity'] = rem_cap

result = input[['TaskID', 'Block Number', 'Remaining Capacity']]

print(result.equals(test))
# True
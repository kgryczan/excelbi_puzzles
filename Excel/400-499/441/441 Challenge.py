import pandas as pd
import re

input = pd.read_excel("441 Integer Intervals.xlsx", usecols="A", nrows=7)
test = pd.read_excel("441 Integer Intervals.xlsx", usecols="B", nrows=7)

result = input.copy()
result['Problem'] = result['Problem'].str.split(", ")
result['row_number'] = result.index
result = result.explode('Problem')
result['Problem'] = result['Problem'].apply(lambda x: list(range(int(x.split('-')[0]), int(x.split('-')[1])+1)) if '-' in x else [int(x)])
result = result.explode('Problem')
result = result.groupby(result.index).agg({'Problem': lambda x: ', '.join(map(str, sorted(set(x))))}).reset_index(drop=True)

print(result['Problem'].equals(test['Answer Expected'])) # True
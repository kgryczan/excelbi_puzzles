import pandas as pd
import re

path = "Excel/800-899/847/847 Sorting.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10)

result  = (input.assign(
    sorted_codes=input['Data'].apply(lambda s: ''.join(sorted(re.findall(r'[A-Z]\d+', s), key=lambda x: int(x[1:])))),
    sum_weight=input['Data'].apply(lambda s: sum(map(int, re.findall(r'\d+', s))))
).sort_values(['sum_weight','Data']))

print(result['sorted_codes'].tolist()) 
print(test['Answer Expected'].tolist())
# one difference in order where full weight is same
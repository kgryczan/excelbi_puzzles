import pandas as pd
import re

path = "642 List Alphabets and Numbers.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=21)
test = pd.read_excel(path, usecols="B:C", skiprows=1, nrows=6).fillna("").astype(str)

input['type'] = input.iloc[:, 0].apply(lambda x: 'Alphabet' if re.match(r'[A-Za-z]', str(x)) else 'Number')
input['consecutive_id'] = (input['type'] != input['type'].shift()).cumsum()
input['Data'] = input['Data'].astype(str)

result = input.groupby('consecutive_id').agg({'Data': ', '.join, 'type': 'first'}).reset_index(drop=True)
result['group'] = result.index // 2

pivot_result = result.pivot(index='group', columns='type', values='Data').reset_index(drop=True).fillna("")
pivot_result.columns.name = None

print(pivot_result.equals(test)) # True

import pandas as pd
import re
import numpy as np

path = "800-899/829/829 Extract Numbers Multiply and Sum.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="A:B", nrows=10)

def extract_numbers(s):
    return re.findall(r'\d+', str(s))

rows = [
    {'Strings': row[0], 'numbers': num, 'odd': i % 2, 'pair': i // 2}
    for row in input.values
    for i, num in enumerate(extract_numbers(row[0]))
]

df = pd.DataFrame(rows)
pivot = df.pivot_table(index=['Strings', 'pair'], columns='odd', values='numbers', aggfunc='first')
pivot = pivot.rename(columns={0: '0', 1: '1'}).fillna(1).astype(int)
pivot['multiply'] = pivot['0'] * pivot['1']

result = pivot.groupby('Strings')['multiply'].sum().reset_index(name="Sum")
test = test.sort_values(by='Strings').reset_index()

print(result['Sum'].equals(test['Answer Expected']))  # True
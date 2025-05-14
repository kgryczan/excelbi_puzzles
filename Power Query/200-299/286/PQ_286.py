import pandas as pd
import re

path = "200-299/286/PQ_Challenge_286.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=5)
test = pd.read_excel(path, usecols="F:H", nrows=13).rename(columns=lambda x: x.replace('.1', ''))

input['rn'] = input.index
cols = ['Animals', 'Food', 'Amount']
input[cols] = input[cols].applymap(lambda x: re.split(r',\s*', x) if isinstance(x, str) and ',' in x else [x])
input['max_len'] = input[cols].applymap(len).max(axis=1)
input['Food_set_len'] = input['Food'].apply(lambda x: len(set(x)))
input['Animals_set_len'] = input['Animals'].apply(lambda x: len(set(x)))
input['Amount'] = input['Amount'].apply(lambda x: [float(i) for i in x])

def expand_row(row):
    for col in cols:
        row[col] = (row[col] * row['max_len'])[:row['max_len']]
    return row

input = input.apply(expand_row, axis=1)
input = input.explode(cols, ignore_index=True)
input['Amount'] = input.apply(
    lambda row: int(row['Amount'] / row['Animals_set_len']) if row['Food_set_len'] < row['Animals_set_len'] else int(row['Amount']),
    axis=1
).astype('int64')
input = input[['Animals', 'Food', 'Amount']]
input = input.rename(columns={'Animals': 'Animal'})

print(input.equals(test)) # True
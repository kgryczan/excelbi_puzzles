import pandas as pd
import numpy as np
import re

path = "700-799/788/788 Quiz_Table.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=30)
test = pd.read_excel(path, usecols="E:J", skiprows=1, nrows=7)

def is_number(val):
    return bool(re.match(r"^[0-9]+$", str(val)))

input['num'] = input['No'].apply(is_number).cumsum()
input['Correct Answer'] = np.where(input['Correct'] == "Y", input['No'], np.nan)
input['Correct Answer'] = input.groupby('num')['Correct Answer'].transform(lambda x: x.ffill().bfill())
input['Q'] = np.where(input['No'].apply(is_number), input['Question'], np.nan)
input['Q'] = input.groupby('num')['Q'].transform(lambda x: x.ffill().bfill())
input = input[~input['No'].apply(is_number)].drop(columns=['Correct'])
result = input.pivot_table(
    index=['num', 'Correct Answer', 'Q'],
    columns='No',
    values='Question',
    aggfunc='first'
).reset_index()
result['Question'] = result['num'].astype(str) + '.' + result['Q'].astype(str)
result = result[['Question', 'A', 'B', 'C', 'D', 'Correct Answer']]

print(result.equals(test)) # True

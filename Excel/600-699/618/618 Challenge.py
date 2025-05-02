import pandas as pd
from datetime import timedelta

path = "618 Project Plan with Relationship.xlsx"
input = pd.read_excel(path, usecols="A:E", skiprows=1, nrows=10)
test = pd.read_excel(path, usecols="F:G", skiprows=1, nrows=10)

input['Start'] = input.apply(lambda row: row['Plan Start'] if row['Task'] == 'Start' else pd.NaT, axis=1)
input['End'] = input['Start'] + input['Duration'].apply(lambda d: timedelta(days=d))

predecessors = input['Predecessor '].dropna().unique()

for pred in predecessors:
    pred_end = input.loc[input['Task'] == pred, 'End'].values[0]
    input.loc[input['Predecessor '] == pred, 'Start'] = pred_end
    input['End'] = input['Start'] + input['Duration'].apply(lambda d: timedelta(days=d))

result = input[['Start', 'End']].reset_index(drop=True)
test.columns = result.columns

print(all(result == test)) # True
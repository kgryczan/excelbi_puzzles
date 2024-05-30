import pandas as pd
import numpy as np

input = pd.read_excel("467 Overlapping Times.xlsx", usecols="A:C", nrows=7)
test = pd.read_excel("467 Overlapping Times.xlsx", usecols="E:L", nrows=8, skiprows=1)
test.columns = ['Task ID'] + list(test.columns[1:])
test = test.set_index('Task ID')

input['key'] = 0
input = input.merge(input, on='key').drop('key', axis=1)
input = input[input['Task ID_x'] != input['Task ID_y']]

input['overlap'] = (input['To Time_x'] >= input['From Time_y']) & (input['From Time_x'] <= input['To Time_y'])
input['overlap'] = input['overlap'].map({True: 'Y', False: np.nan})

input = input[['Task ID_x', 'Task ID_y', 'overlap']]
input = input.pivot(index='Task ID_x', columns='Task ID_y', values='overlap')

input.reset_index(drop=True, inplace=True)
input.fillna('', inplace=True)
test.reset_index(drop=True, inplace=True)
test.fillna('', inplace=True)

test.columns = input.columns
print(input.equals(test))
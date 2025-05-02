import pandas as pd

input = pd.read_excel("449 Rotated Strings.xlsx",  usecols="A:B").sort_values(by='String1')
test = pd.read_excel("449 Rotated Strings.xlsx",  usecols="C:D", nrows=5)
test.columns = input.columns
test = test.sort_values(by='String1').reset_index(drop=True)

def is_rotated(original, check):
    return check in original + original and original != check and len(original) == len(check)

input['Rotated'] = input.apply(lambda x: is_rotated(x['String1'], x['String2']), axis=1)
input = input[input['Rotated'] == True].drop(columns='Rotated').reset_index(drop=True)

print(input.equals(test)) # True

input2  = input[input.apply(lambda x: x['String2'] in (x['String1'] + x['String1']) and x['String1'] != x['String2'] and len(x['String1']) == len(x['String2']), axis=1)].reset_index(drop=True)

print(input2.equals(test)) # True
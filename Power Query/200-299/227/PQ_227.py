import pandas as pd
import re

path = "PQ_Challenge_227.xlsx"
input1 = pd.read_excel(path,  usecols="A:D", skiprows=1, nrows=11)
input2 = pd.read_excel(path,  usecols="F:H", skiprows=1, nrows=4)
test = pd.read_excel(path, usecols="J:N", skiprows=1, nrows=9).rename(columns=lambda x: x.replace('.1', '').replace('.2', ''))\
    .sort_values(by=['Sequence', 'Name']).reset_index(drop=True)

input2['pattern_seq'] = ["^1.*", "321", ".*", ".*8$"]
input2['pattern_name'] = ["^M.*", "^S.*", ".*[aA]$", ".*"]

input = input1.assign(key=1).merge(input2.assign(key=1), on='key').drop('key', axis=1)

input['both_conditions'] = input.apply(
    lambda row: bool(re.match(row['pattern_seq'], str(row['Sequence']))) and 
                bool(re.match(row['pattern_name'], str(row['Name']))), axis=1)

input = input[input['both_conditions']].copy().reset_index(drop=True)
input = input[['Sequence', 'Name', 'Weight', 'Bonus %', 'Salary']].sort_values(by=['Sequence', 'Name']).reset_index(drop=True)

print(input.equals(test)) # True
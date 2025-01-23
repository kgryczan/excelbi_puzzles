import pandas as pd
import numpy as np

path = "637 Insert Dash At Non Consecutive Character.xlsx"
input = pd.read_excel(path, usecols="A", nrows=8)
test = pd.read_excel(path, usecols="B", nrows=8)

def process_string(string):
    result = [string[0]]
    for i in range(1, len(string)):
        if (ord(string[i]) - ord(string[i-1]) != 1):
            result.append('-')
        result.append(string[i])
    return ''.join(result)

input['processed'] = input.iloc[:, 0].apply(process_string)

print(test['Answer Expected'] == input['processed'])

# 0     True
# 1     True
# 2     True
# 3     True
# 4     True
# 5     True
# 6    False  AB in this string can be pair once. 

import pandas as pd
import numpy as np
import re

path = "Excel/900-999/903/903 All Numbers in the Range.xlsx"
input_data = pd.read_excel(path, usecols="A", nrows=11)
test_data = pd.read_excel(path, usecols="B", nrows=5)

def funA(string):
    x = re.split(r', ', string)
    x = np.concatenate([np.arange(int(r.split('-')[0]), int(r.split('-')[1]) + 1) if '-' in r else [int(r)] for r in x])
    max_x = max(x)
    min_x = min(x)
    full_seq = np.arange(min_x, max_x + 1)
    return np.all(np.isin(full_seq, x))

input_data['Result'] = input_data['Data'].apply(funA)
output = input_data[input_data['Result']]

print(output['Data'].tolist() == test_data['Answer Expected'].tolist())
# True
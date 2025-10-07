import pandas as pd
import numpy as np

path = "800-899/820/820 Stack Text and Numbers.xlsx"
input_df = pd.read_excel(path, usecols="A", skiprows=1, nrows=9, dtype=str)
test = pd.read_excel(path, usecols="B:C", skiprows=1, nrows=23)

def split_consistent_type(s):
    types = ['num' if c.isdigit() else 'text' for c in s]
    result = []
    start = 0
    for i in range(1, len(s)+1):
        if i == len(s) or types[i] != types[i-1]:
            result.append(s[start:i])
            start = i
    return result

input = input_df.copy()
input['Split'] = input.iloc[:, 0].apply(split_consistent_type) 
input = input.explode('Split').reset_index(drop=True)
input['ggr'] = input['Split'].apply(lambda x: 0 if x.isdigit() else 1)
input['ggr_cumsum'] = input.groupby(input.columns[0])['ggr'].cumsum()


input['ggr'] = input['ggr'].map({1: 'Text', 0: 'Numbers'})
pivot = input.pivot(index=[input.columns[0], 'ggr_cumsum'], columns='ggr', values='Split')
pivot['Numbers'] = pd.to_numeric(pivot['Numbers'], errors='coerce')

result = pd.merge(input_df, pivot, left_on=input.columns[0], right_on=input.columns[0], how='left')
result = result[['Text','Numbers']]

print(result.equals(test)) #True
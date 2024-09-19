import pandas as pd
import numpy as np

path = "547 Sum and Diff both Triangular Numbers.xlsx"
test = pd.read_excel(path, usecols="A")

def generate_triangular_numbers(n):
    return [i * (i + 1) // 2 for i in range(1, n + 1)]


def is_triangular_number(n):
    return ((8 * n + 1) ** 0.5).is_integer()

triangulars = generate_triangular_numbers(2000)

triangulars_df = pd.DataFrame({'t1': triangulars})
result = triangulars_df.assign(key=0).merge(triangulars_df.assign(key=0), on='key').drop(columns='key')
result.columns = ['t1', 't2']

result = result[(result['t1'] < result['t2']) & 
                (result['t1'] + result['t2']).apply(is_triangular_number) & 
                (abs(result['t2'] - result['t1'])).apply(is_triangular_number) & 
                (result['t1'] != result['t2'])].reset_index(drop=True)

result['output'] = result['t1'].astype(str) + ', ' + result['t2'].astype(str)
result = result.head(20)

print(result['output'].equals(test["Answer Expected"]))
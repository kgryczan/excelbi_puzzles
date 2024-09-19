import pandas as pd

path = "547 Sum and Diff both Triangular Numbers.xlsx"
test = pd.read_excel(path, usecols="A")

def generate_triangular_numbers(limit):
    return [n * (n + 1) // 2 for n in range(1, int((2 * limit) ** 0.5) + 1)]

def is_triangular_number(n):
    return ((8 * n + 1) ** 0.5).is_integer()

triangulars = generate_triangular_numbers(1000000)

triangulars_df = pd.DataFrame({'t1': triangulars})
result = triangulars_df.assign(key=0).merge(triangulars_df.assign(key=0), on='key').drop(columns='key')
result.columns = ['t1', 't2']

result = result[(result['t1'] < result['t2']) & 
                (result['t1'] + result['t2']).apply(is_triangular_number) & 
                (abs(result['t2'] - result['t1'])).apply(is_triangular_number) & 
                (result['t1'] != result['t2'])].reset_index(drop=True)

print(result)
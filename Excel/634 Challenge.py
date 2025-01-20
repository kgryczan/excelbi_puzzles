import pandas as pd

path = "634 Array Equality.xlsx"
input = pd.read_excel(path,  usecols="A:B", skiprows=1, nrows=9)
test = pd.read_excel(path,  usecols="D:E", skiprows=1, nrows=5).rename(columns=lambda x: x.split('.')[0])

def split_sort_unique(s):
    return sorted(set(s.split(',')))

input['set_array1'] = input['Array1'].apply(split_sort_unique)
input['set_array2'] = input['Array2'].apply(split_sort_unique)
input['result'] = input.apply(lambda row: row['set_array1'] == row['set_array2'], axis=1)
result = input[input['result'] == True][['Array1', 'Array2']].reset_index(drop=True)

print(result.equals(test)) #Free
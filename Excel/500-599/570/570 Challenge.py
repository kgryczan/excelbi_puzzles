import pandas as pd

path = "570 Position Swapping.xlsx"
input = pd.read_excel(path,usecols="A:B", nrows=10)
test = pd.read_excel(path,usecols="C", nrows=10)

def swap_string_tidy(string, numbers):
    str_list = list(string)
    indices = [int(num) - 1 for num in numbers.split(',')]
    for i in range(0, len(indices), 2):
        str_list[indices[i]], str_list[indices[i+1]] = str_list[indices[i+1]], str_list[indices[i]]
    return ''.join(str_list)

input['Swapped'] = input.apply(lambda row: swap_string_tidy(row['String'], row['Numbers']), axis=1)

print(input['Swapped'].equals(test['Answer Expected'])) # True
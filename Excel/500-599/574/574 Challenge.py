import pandas as pd

path = "574 Sort Numbers in Odd Positions Only.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10, dtype=str)

def process_numbers(number):
    number = list(str(number))
    odd_indices = range(0, len(number), 2)
    odd_numbers = sorted(int(number[i]) for i in odd_indices)
    for i, idx in enumerate(odd_indices):
        number[idx] = str(odd_numbers[i])
    return ''.join(number)

input['Answer Expected'] = input.iloc[:, 0].apply(process_numbers)

print(test['Answer Expected'].equals(input['Answer Expected']))
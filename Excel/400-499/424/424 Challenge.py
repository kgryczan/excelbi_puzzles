import pandas as pd

input = pd.read_excel('424 Insert in Between Multiplication.xlsx', usecols='A', nrows=9)
test  = pd.read_excel('424 Insert in Between Multiplication.xlsx', usecols='B', nrows=9)

def transform_number(number):
    digits = [int(digit) for digit in str(number)]
    transformed_digits = [digits[i] * digits[i+1] for i in range(len(digits)-1)]
    transformed_digits.append('')
    mixed_digits = [digit for pair in zip(digits, transformed_digits) for digit in pair]
    result = ''.join(map(str, mixed_digits))
    return result

input["Answer Expected"] = input["Words"].apply(transform_number)

print(input["Answer Expected"].equals(test["Answer Expected"])) # True
import pandas as pd
import numpy as np

path = "700-799/718/718 Divisible by All Digits.xlsx"
test = pd.read_excel(path, usecols="A", nrows=10001)

numbers = np.arange(10, 10_000_001)
numbers_str = numbers.astype(str)

mask_no_zero = np.char.find(numbers_str, '0') == -1
filtered_numbers = numbers[mask_no_zero]
filtered_numbers_str = numbers_str[mask_no_zero]

def passes_divisibility_rule(number_str):
    digits = [int(d) for d in number_str]
    for i in range(len(digits)):
        removed = digits[i]
        if removed == 0:
            return False
        remaining_digits = digits[:i] + digits[i+1:]
        if not remaining_digits:
            continue
        remaining_number = int(''.join(map(str, remaining_digits)))
        if remaining_number % removed != 0:
            return False
    return True

valid = [passes_divisibility_rule(s) for s in filtered_numbers_str]
result = pd.DataFrame({'Numbers': filtered_numbers})[valid].head(10000).reset_index(drop=True)

print(result.equals(test)) # True
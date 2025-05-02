import pandas as pd

path = "657 Largest Alternating Even Odd or Odd Even Substring.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10).astype(str)

def generate_substrings(num_str):
    return list(set(num_str[i:j] for i in range(len(num_str)) for j in range(i + 1, len(num_str) + 1)))

def is_alternating(num_str):
    return all((int(num_str[i]) % 2) != (int(num_str[i + 1]) % 2) for i in range(len(num_str) - 1))

def largest_alternating_substring(number):
    num_str = str(number)
    valid_substrings = [s.lstrip('0') or '0' for s in generate_substrings(num_str) if is_alternating(s)]
    if not valid_substrings:
        return None
    max_length = max(len(s) for s in valid_substrings)
    return max(s for s in valid_substrings if len(s) == max_length)

input['LAS'] = input.iloc[:, 0].apply(largest_alternating_substring)

print(input['LAS'].equals(test['Answer Expected'])) # True
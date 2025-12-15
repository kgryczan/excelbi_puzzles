import pandas as pd

path = "Excel/800-899/869/869 Extract nums.xlsx"
input_df = pd.read_excel(path, usecols="A", nrows=100)
test_df = pd.read_excel(path, usecols="B", nrows=100)

def extract_inc_seq_simple(s):
    digits = [int(ch) for ch in str(s)]
    result = []
    last_num = float('-inf')
    i = 0
    n = len(digits)
    while i < n:
        found = False
        for j in range(i, n):
            candidate = int(''.join(str(d) for d in digits[i:j+1]))
            if candidate > last_num:
                result.append(candidate)
                last_num = candidate
                i = j + 1
                found = True
                break
        if not found:
            break
    return ', '.join(str(x) for x in result)

input_df['Extracted'] = input_df.iloc[:, 0].apply(extract_inc_seq_simple)

print(all(input_df['Extracted'] == test_df.iloc[:, 0]))
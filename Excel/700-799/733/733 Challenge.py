import pandas as pd

path = "700-799/733/733.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=11)
test = pd.read_excel(path, usecols="C", nrows=11)

def rotate_string(s, n):
    if not s:
        return s
    n = n % len(s)
    return s[-n:] + s[:-n]

input['Rotation'] = input['Rotation'].astype(str).str.split(', ').apply(lambda x: sum(map(int, x)))
input['Answer Expected'] = input.apply(lambda row: rotate_string(row['Words'], row['Rotation']), axis=1)

print(input['Answer Expected'].equals(test['Answer Expected'])) # True

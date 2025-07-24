from itertools import permutations
import pandas as pd

path = "700-799/767/767 Distinct Digits.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=6)
test = pd.read_excel(path, usecols="C:E", nrows=6)

def distinct_digit_perms(f, t):
    res = []
    for d in range(len(str(f)), len(str(t)) + 1):
        for p in permutations('0123456789', d):
            if p[0] != '0':
                n = int(''.join(p))
                if f <= n <= t:
                    res.append(n)
    return len(res), min(res), max(res)

input[['Count', 'Min', 'Max']] = pd.DataFrame(
    input.apply(lambda r: distinct_digit_perms(r['From'], r['To']), axis=1).tolist(), index=input.index
)
input.drop(columns=['From', 'To'], inplace=True)

print(input.equals(test))
# > True
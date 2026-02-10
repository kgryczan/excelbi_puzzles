import pandas as pd

path = "Excel/900-999/910/910 Increasing Numbers.xlsx"
input = pd.read_excel(path, usecols="A", nrows=11)
test = pd.read_excel(path, usecols="B", nrows=11)

def split_inc(s):
    i, prev, out = 1, int(s[0]), [s[0]]
    while i < len(s):
        for j in range(i + 1, len(s) + 1):
            cand = s[i:j]
            if int(cand) > prev:
                out.append(cand)
                prev, i = int(cand), j
                break
        else:
            break
    return ", ".join(out)

input['Split Numbers'] = input['Digit Strings (Input)'].astype(str).apply(split_inc)
print(input['Split Numbers'] == test['Answer Expected'])
# 3 different
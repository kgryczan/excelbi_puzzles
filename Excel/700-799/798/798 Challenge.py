import pandas as pd

path = "700-799/798/798 From back - Extract String Before a Repeated Character.xlsx"
input = pd.read_excel(path, usecols="A", nrows=11)
test = pd.read_excel(path, usecols="B", nrows=11)

def cut_at_first_global_dup(x):
    result = []
    for s in x:
        chars = list(str(s))
        counts = pd.Series(chars).value_counts()
        dups = counts[counts > 1].index.tolist()
        if not dups:
            result.append(s)
            continue
        starts = [chars.index(d) for d in dups]
        start = max(starts) + 1
        result.append(''.join(chars[start:]))
    return result

input['Answer Expected'] = cut_at_first_global_dup(input.iloc[:, 0])
print(input['Answer Expected'] == test.iloc[:, 0])
# one solution different from expected

import pandas as pd

path = "Excel\\800-899\\885\\885 Case Position Swap Cipher.xlsx"
input = pd.read_excel(path, usecols="A", nrows = 19)
test = pd.read_excel(path, usecols="B", nrows = 19)

def swap_case_pos(s):
    x = list(s)
    up = [i for i,c in enumerate(x) if c.isupper()]
    lo = [i for i,c in enumerate(x) if c.islower()]
    n = min(len(up), len(lo))
    for i in range(n):
        x[up[i]], x[lo[i]] = x[lo[i]], x[up[i]]
    return "".join(x)

result = input.assign(Output=input["CipherText"].map(swap_case_pos))
print(result['Output'].equals(test['Answer Expected'])) # True
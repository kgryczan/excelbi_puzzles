import pandas as pd

path = "700-799/773/773 Missing Numbers.xlsx"

input1 = pd.read_excel(path, header=None, usecols="A:C", skiprows=1, nrows=2)
input2 = pd.read_excel(path, header=None, usecols="A:E", skiprows=4, nrows=3)
input3 = pd.read_excel(path, header=None, usecols="A:G", skiprows=8, nrows=4)
input4 = pd.read_excel(path, header=None, usecols="A:M", skiprows=13, nrows=7)

test1 = str(pd.read_excel(path, header=None, usecols="O", skiprows=1, nrows=1).iloc[0, 0])
test2 = str(pd.read_excel(path, header=None, usecols="O", skiprows=4, nrows=1).iloc[0, 0])
test3 = pd.read_excel(path, header=None, usecols="O", skiprows=8, nrows=1).iloc[0, 0]
test4 = pd.read_excel(path, header=None, usecols="O", skiprows=13, nrows=1).iloc[0, 0]

def find_missing_triangle_values(df):
    df = df.copy().astype(str)
    res = []
    for row in df.values:
        for j, val in enumerate(row):
            if val == "X":
                l = row[j-1] if j > 0 else None
                r = row[j+1] if j < len(row)-1 else None
                try: l = float(l) if l not in [None, 'nan'] else None
                except: l = None
                try: r = float(r) if r not in [None, 'nan'] else None
                except: r = None
                if l is None and r is None: v = 1
                elif l is not None and r is None: v = l + 1
                elif l is None and r is not None: v = r + 1
                elif l == r: v = l - 1
                else: v = (l + r) / 2
                res.append(int(v) if v == int(v) else v)
    return ", ".join(map(str, res))

print(find_missing_triangle_values(input1) == test1)
print(find_missing_triangle_values(input2) == test2)
print(find_missing_triangle_values(input3) == test3)
print(find_missing_triangle_values(input4) == test4)
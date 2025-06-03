import pandas as pd

path = "700-799/730/730 Pick the Odd Numbers in a Grid Across Diagonals.xlsx"

input1 = pd.read_excel(path, header=None, usecols="A:B", skiprows=1, nrows=2).to_numpy()
input2 = pd.read_excel(path, header=None, usecols="A:C", skiprows=4, nrows=3).to_numpy()
input3 = pd.read_excel(path, header=None, usecols="A:C", skiprows=8, nrows=3).to_numpy()
input4 = pd.read_excel(path, header=None, usecols="A:D", skiprows=12, nrows=4).to_numpy()
input5 = pd.read_excel(path, header=None, usecols="A:E", skiprows=17, nrows=5).to_numpy()
test1 = str(pd.read_excel(path, header=None, usecols="G", skiprows=1, nrows=1).iloc[0,0])
test2 = ""
test3 = str(pd.read_excel(path, header=None, usecols="G", skiprows=8, nrows=1).iloc[0,0])
test4 = pd.read_excel(path, header=None, usecols="G", skiprows=12, nrows=1).iloc[0,0]
test5 = pd.read_excel(path, header=None, usecols="G", skiprows=17, nrows=1).iloc[0,0]

def print_odd_diagonals(m):
    n = len(m)
    d1 = int(''.join(str(m[i][i]) for i in range(n)))
    d2 = int(''.join(str(m[i][n-1-i]) for i in range(n)))
    odds = [str(x) for x in {d1, d2} if x % 2]
    if not odds:
        return ""
    return ', '.join(odds)


print(print_odd_diagonals(input1) == (test1)) # True
print(print_odd_diagonals(input2) == (test2)) # True
print(print_odd_diagonals(input3) == (test3)) # True
print(print_odd_diagonals(input4) == (test4)) # True
print(print_odd_diagonals(input5) == (test5)) # True

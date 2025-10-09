import pandas as pd

path = "800-899/822/822 Largest N Digit Numbers in Grids.xlsx"
input1 = pd.read_excel(path, header=None, usecols="A:C", skiprows=2, nrows=3).values
test1  = pd.read_excel(path, header=None, usecols="J:M", skiprows=2, nrows=1).values.flatten(); test1 = [x for x in test1 if pd.notna(x)]
input2 = pd.read_excel(path, header=None, usecols="A:D", skiprows=6, nrows=4).values
test2  = pd.read_excel(path, header=None, usecols="J:M", skiprows=6, nrows=1).values.flatten(); test2 = [x for x in test2 if pd.notna(x)]
input3 = pd.read_excel(path, header=None, usecols="A:E", skiprows=11, nrows=5).values
test3 = pd.read_excel(path, header=None, usecols="J:M", skiprows=11, nrows=1).values.flatten(); test3 = [x for x in test3 if pd.notna(x)]

def roll_max_num(v, n):
    v = [str(x) for x in v]
    if len(v) < n:
        return float('-inf')
    nums = [int(''.join(v[i:i+n])) for i in range(len(v)-n+1)]
    return max(nums)

def max_for_N(mat, n):
    rows = [roll_max_num(row, n) for row in mat]
    cols = [roll_max_num(col, n) for col in mat.T]
    return max(rows + cols)

result1 = [max_for_N(input1, n) for n in range(2, input1.shape[0]+1)]
result2 = [max_for_N(input2, n) for n in range(2, input2.shape[0]+1)]
result3 = [max_for_N(input3, n) for n in range(2, input3.shape[0]+1)]

print(result1 == test1)  # one different than provided
print(result2 == test2)  # all correct
print(result3 == test3)  # two different than provided


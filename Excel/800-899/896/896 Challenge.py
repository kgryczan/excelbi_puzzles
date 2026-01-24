import pandas as pd

path = "Excel/800-899/896/896 Color Mixing.xlsx"
input = pd.read_excel(path, usecols="A", nrows=20)
test = pd.read_excel(path, usecols="B", nrows=20)

def mix(x, y):
    if x == y:
        return x
    else:
        return list(set(['r', 'b', 'y']) - set([x, y]))[0]

def reduce_mix(code):
    from functools import reduce
    return reduce(mix, list(code))

input['Answer Expected'] = input['Color Codes'].apply(lambda x: reduce_mix(str(x)))
result = input[['Answer Expected']]

print(result.equals(test))

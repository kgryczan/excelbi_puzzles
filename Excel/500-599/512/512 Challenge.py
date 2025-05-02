import pandas as pd

path = "512 Next Sparse Number.xlsx"
input = pd.read_excel(path, usecols="A")
test  = pd.read_excel(path, usecols="B")

def next_no_adjacent_ones(n):
    n += 1
    while True:
        if '11' not in bin(n):
            return n
        n += 1

# apply the function to the input, creating column `Answer Expected`
result = input.copy()
result['Answer Expected'] = result['Number'].apply(next_no_adjacent_ones)

print(result['Answer Expected'].equals(test['Answer Expected']))
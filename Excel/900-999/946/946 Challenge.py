import pandas as pd

path = "900-999/946/946 Single Answer After Iteration.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10, skiprows=0)
test = pd.read_excel(path, usecols="B", nrows=10, skiprows=0).to_numpy().flatten()

def reduce_to_single(x):
    nums = x.split(",")
    numbers = [int(num) for num in nums]
    diffs = [abs(numbers[i] - numbers[i+1]) for i in range(len(numbers)-1)]
    while len(set(diffs)) > 1:
        diffs = [abs(diffs[i] - diffs[i+1]) for i in range(len(diffs)-1)]

    return diffs[0]

result = input["Input"].apply(reduce_to_single).to_numpy().flatten()

print((result==test).all())
# True

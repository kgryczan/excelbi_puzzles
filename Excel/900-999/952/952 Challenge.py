import pandas as pd

path = "900-999/952/952 Minimum Button Presses.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=9)
test = pd.read_excel(path, usecols="C", nrows=9)

def min_presses(start, target):
    steps = 0
    while target > start:
        if target % 2 == 0:
            target //= 2
        else:
            target += 1
        steps += 1
    return steps + (start - target)
input["Output"] = input.apply(lambda row: min_presses(row["Start"], row["Target"]), axis=1)
print(input['Output'].equals(test['Answer Expected']))
# Output: True
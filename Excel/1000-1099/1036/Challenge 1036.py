import itertools
import pandas as pd

path = "1000-1099/1036/1036 Max Zig Zag Length.xlsx"
input = pd.read_excel(path, usecols="A", nrows=20)
test = pd.read_excel(path, usecols="A:B", nrows=20)


def max_zigzag(text):
    numbers = [int(x) for x in text.split(", ")]
    current = best = 1
    previous_sign = 0

    for left, right in itertools.pairwise(numbers):
        sign = (right > left) - (right < left)
        current = current + 1 if sign and sign != previous_sign else 2 if sign else 1
        best = max(best, current)
        previous_sign = sign
    return best


result = input.assign(**{"Answer Expected": input.Data.map(max_zigzag)})
print(result.equals(test))

import math
import pandas as pd

path = "900-999/937/937 Number Equal to Sum of Digits.xlsx"
input_df = pd.read_excel(path, usecols="A", nrows=12)
test = pd.read_excel(path, usecols="B", nrows=12)

def smallest_digit_sum(N):
    d = max(2, math.ceil(N / 9))
    first = N - 9 * (d - 1)
    if first <= 0:
        return int("1" + str(N - 1))
    else:
        return int(str(first) + "9" * (d - 1))

result = input_df["Number"].apply(smallest_digit_sum)

print(result.equals(test["Answer Expected"]))
# True

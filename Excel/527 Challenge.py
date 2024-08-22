import pandas as pd
import numpy as np

path = "527 Sum of Digits in Different Bases.xlsx"
input = pd.read_excel(path, usecols = "A")
test  = pd.read_excel(path, usecols = "B")

def convert_to_sum(number):
    digits = [int(d) for d in str(number)]
    rows = np.arange(len(digits), 0, -1) + 1
    digits = [int(np.base_repr(d, base = r)) for d, r in zip(digits, rows)]
    return sum(digits)

result = input.assign(Sum=input["Number"]\
            .apply(convert_to_sum))\
            .sort_values(by="Sum")\
            .drop("Sum", axis=1)\
            .reset_index(drop=True)

print(result["Number"].equals(test["Answer Expected"])) # True
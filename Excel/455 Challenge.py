import pandas as pd
import numpy as np

input = pd.read_excel("455 Anti perfect numbers.xlsx", sheet_name="Sheet1", usecols="A")
test = pd.read_excel("455 Anti perfect numbers.xlsx", sheet_name="Sheet1", usecols="B", nrows = 4)

def is_antiperfect(number):
    divisors = [i for i in range(1, number) if number % i == 0]
    reversed_divisors = [int(str(i)[::-1]) for i in divisors]
    sum_rev_div = sum(reversed_divisors)
    return sum_rev_div == number

input["is_antiperfect"] = input["Numbers"].apply(is_antiperfect)
result = input[input["is_antiperfect"]]["Numbers"].rename("Expected Answer").astype("int64").reset_index(drop=True)

print(result.equals(test["Expected Answer"])) # True

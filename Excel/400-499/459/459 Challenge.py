import pandas as pd
import math

input = pd.read_excel("459 Next Perfect Square.xlsx", usecols="A")
test  = pd.read_excel("459 Next Perfect Square.xlsx", usecols="B")

def find_next_perf_square(n):
    return (math.floor(math.sqrt(n)) + 1) ** 2

result = input["Number"].apply(find_next_perf_square)

print(result.equals(test["Answer Expected"])) # True
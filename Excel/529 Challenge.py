import pandas as pd
import re

pattern = r"(?<=\D)[+-]?\d+[+-]?"

path = "529 Sum with Signs.xlsx"
input = pd.read_excel(path, usecols="A")
test = pd.read_excel(path, usecols="B")

def adjust_numbers(s):
    numbers = re.findall(pattern, s)
    adjusted_numbers = [int(num[:-1]) if num.endswith('+') else -int(num[:-1]) if num.endswith('-') else int(num) for num in numbers]
    return sum(adjusted_numbers)

input = input.map(adjust_numbers)

print(input["Strings"].equals(test["Answer Expected"])) # True
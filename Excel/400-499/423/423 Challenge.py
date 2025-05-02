import pandas as pd
import re

input = pd.read_excel("423 Split Case Sensitive Alphabets and Numbers.xlsx", usecols="A", nrows=10)
test = pd.read_excel("423 Split Case Sensitive Alphabets and Numbers.xlsx", usecols="B", nrows=10)

pattern = r"[A-Z]+|[a-z]+|[0-9]+"

result = input["Data"].apply(lambda x: ", ".join(re.findall(pattern, str(x))))

print(test["Expected Answer"].equals(result)) # True
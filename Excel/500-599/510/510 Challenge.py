import pandas as pd
import re

path = "510 Find Upper, Lower, Numbers & Special Chars Count.xlsx"
input = pd.read_excel(path, usecols = "A", skiprows = 1)
test = pd.read_excel(path, usecols = "B:E", skiprows = 1)

result = input.copy()
result["Data"] = result["Data"].fillna("")
result["Upper Case"] = result["Data"].apply(lambda x: len(re.findall("[A-Z]", x)))
result["Lower Case"] = result["Data"].apply(lambda x: len(re.findall("[a-z]", x)))
result["Numbers"] = result["Data"].apply(lambda x: len(re.findall("[0-9]", x)))
result["Special Chars"] = result["Data"].apply(lambda x: len(re.findall("[^A-Za-z0-9]", x)))

result = result.drop(columns=["Data"])

print(result.equals(test)) # True
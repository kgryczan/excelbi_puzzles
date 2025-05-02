import pandas as pd

path = "504 US Presidents All First Chars Same.xlsx"
input = pd.read_excel(path, usecols="A")
test = pd.read_excel(path, usecols="B", nrows = 4)

result = input[input['US Presidents'].apply(lambda x: len(set([i[0] for i in x.split()])) == 1)].reset_index(drop=True)

print(result["US Presidents"].equals(test["Answer Expected"])) # True
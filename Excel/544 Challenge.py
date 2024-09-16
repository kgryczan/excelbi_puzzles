import pandas as pd

path = "544 Sum of First and Last Numbers.xlsx"
input = pd.read_excel(path, usecols = "A")
test  = pd.read_excel(path, usecols = "B", nrows = 1).values[0][0]

result = input.copy()
result["Numbers"] = result["Strings"].str.findall(r"[-+]?\d*\.\d+|\d+").apply(lambda x: [int(i) for i in x])
result["Sum"] = result["Numbers"].apply(lambda x: x[0] + x[-1] if len(x) > 1 else x[0] if len(x) == 1 else 0)
result = result["Sum"].sum()

print(result == test) # True
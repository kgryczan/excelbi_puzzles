import pandas as pd

path = "559 Max of first N elements.xlsx"
input = pd.read_excel(path, usecols="A:D", skiprows=1)
test = pd.read_excel(path, usecols="F:I", skiprows=1, names=["A", "B", "C", "D"])

result = input.cummax()
result.columns = ["A", "B", "C", "D"]

print(result.equals(test)) # True

import pandas as pd

input = pd.read_excel("469 Split.xlsx",  usecols="A", skiprows = 1, nrows = 8)
test = pd.read_excel("469 Split.xlsx",  usecols="C:H", skiprows = 1, nrows = 8)

result = input.copy()
result = result.assign(rn=result.index + 1, split=result["Data"].str.split(", "))
result = result.explode("split").drop(columns=["Data"])
result = result.pivot(index="rn", columns="split", values="split").reset_index(drop=True).rename_axis(None, axis=1)
result = result.iloc[:, 1:7]

print(result.equals(test)) # True
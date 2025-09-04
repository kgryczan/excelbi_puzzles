import pandas as pd

path = "700-799/797/797 Cage Alignment.xlsx"
input1 = pd.read_excel(path, usecols="A", skiprows=1, nrows=4)
input2 = pd.read_excel(path, usecols="B", skiprows=1, nrows=31)
test = pd.read_excel(path, usecols="D:E", skiprows=1, nrows=12).rename(columns=lambda c: c.replace('.1', ''))

i1 = input1['Cage'].str.split(", ", expand=True)
i1 = i1.loc[i1.index.repeat(i1[1].astype(int))].reset_index(drop=True)
i1["rn"] = i1.index + 1
i1.columns = ["Cage", "volume", "rn"]

i2 = input2.copy()
i2["rn"] = i2.index + 1

result = pd.merge(i1, i2, on="rn", how="left").drop(columns=["rn", "volume"])
result["Cage"] = result.groupby("Cage")["Cage"].transform(lambda x: x.where(x.index == x.index.min(), None))

print(result.equals(test)) # True
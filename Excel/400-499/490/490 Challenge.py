import pandas as pd

path = "490 - Fill Down.xlsx"
input = pd.read_excel(path, usecols="A:B")
test = pd.read_excel(path, usecols="C:C")

result = input.copy()
result["Level 1"].fillna(method="ffill", inplace=True)
result["group"] = (result["Level 1"] != result["Level 1"].shift()).cumsum()
result["nr1"] = result.groupby("group").cumcount() + 1
result["L2"] = (~result["Level 2"].isna()) & (result["nr1"] != 1)
result["L2_n2"] = result.groupby("group")["L2"].cumsum()
result.loc[~result["L2"], "L2_n2"] = 0
result["Answer Expected"] = result["group"].astype(str) + "." + result["L2_n2"].astype(str)
result = result[["Answer Expected"]].astype("float64").reset_index(drop=True)

print(result.equals(test)) # True
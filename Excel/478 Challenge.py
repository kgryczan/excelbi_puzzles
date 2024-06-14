import pandas as pd

path = "478 Merge Tables.xlsx"

input1 = pd.read_excel(path, skiprows=1, usecols="A:C", nrows = 7)
input2 = pd.read_excel(path, skiprows=1, usecols="E:H", nrows = 8)
input2.columns = input2.columns.str.replace(r'\.\d+', '', regex=True)
test = pd.read_excel(path,  skiprows=1, usecols="J:M")
test.columns = test.columns.str.replace(r'\.\d+', '', regex=True)

result = pd.merge(input1, input2, on=["Org", "Year"], how="outer").sort_values(by=["Org", "Year"])
result["Sales"] = result[["Sales_x", "Sales_y"]].sum(axis=1, skipna=True).astype("int64")
result = result[["Org", "Year", "Prime", "Sales"]].reset_index(drop=True)

print(result.equals(test)) # True   
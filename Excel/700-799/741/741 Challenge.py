import pandas as pd
import re

path = "700-799/741/741 Pivot.xlsx"
input_df = pd.read_excel(path, usecols="A", skiprows=1, nrows=8, names=["Data"])
test = pd.read_excel(path, usecols="C:F", skiprows=1, nrows=3)

input_df["Item"] = [re.search(r'Item\d+', s).group(0) if re.search(r'Item\d+', s) else None for s in input_df["Data"]]
input_df["Group"] = [re.search(r'Group (\w)', s).group(1) if re.search(r'Group (\w)', s) else None for s in input_df["Data"]]
input_df["Data"] = [sum(map(int, re.findall(r'\d+', re.sub(r'Item\d+|Group [ABC]', '', s)))) for s in input_df["Data"]]

result = input_df.pivot_table(index="Group", columns="Item", values="Data", aggfunc="sum").reset_index()

print(test.equals(result)) # True
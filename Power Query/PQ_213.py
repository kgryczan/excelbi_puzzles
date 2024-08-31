import pandas as pd
import numpy as np

path = "PQ_Challenge_213.xlsx"

T1 = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=6)
T2 = pd.read_excel(path, usecols="A:C", skiprows=11, nrows=6)
test = pd.read_excel(path, usecols="F:K", skiprows=1, nrows=7).fillna(0)
test.columns = test.columns.str.replace(".1", "")

for col in test.columns[1:]:
    test[col] = test[col].astype("int64")


T_full = pd.concat([T1, T2], ignore_index=True)
T_full = T_full.assign(Item=T_full.Item.str.split(", ")).explode("Item")
T_full = T_full.assign(Group=T_full.Group.str.split(", ")).explode("Group").reset_index(drop=True)
T_full = T_full.pivot_table(index="Group", columns="Item", values="Stock", aggfunc = "sum", fill_value=0, margins = True, margins_name = "Total").reset_index()
T_full.columns.name = None

print(T_full.equals(test)) # True
print(T_full.dtypes)
print(test.dtypes)
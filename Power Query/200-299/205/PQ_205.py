import pandas as pd
import numpy as np

path = "PQ_Challenge_205.xlsx"
input1 = pd.read_excel(path, usecols="A:B", skiprows=1)
input2 = pd.read_excel(path, usecols="D:E", skiprows=1)
input2.columns = input2.columns.str.replace(".1", "")
test  = pd.read_excel(path, usecols="H:L", skiprows=1, nrows = 6)
test.columns = test.columns.str.replace(".1", "")
test = test.fillna("")

input = pd.merge(input1, input2, on="Item", how="inner")\
    .sort_values(by=["YesNo", "Item"], ascending=[False, True])\
    .reset_index(drop=True)

input["nr"] = input.groupby("YesNo").cumcount() + 1
input["nr_rem"] = input["nr"] % 2
input["nr_int"] = np.where(input["nr_rem"] == 1, input["nr"] // 2 + 1, input["nr"] // 2)

input = input.pivot(index=["YesNo", "nr_int"], columns="nr_rem", values=["Item", "Value"]).reset_index()
input.columns = [f"{a}{b}" for a, b in input.columns]
input["Value0"] = input["Value0"].fillna(0)
input["Sum"] = input["Value0"] + input["Value1"]
input["%age"] = input.groupby("YesNo")["Sum"].transform(lambda x: x / x.sum())

input.drop(columns=["Value0", "Value1", "nr_int"], inplace=True)
input = input[["YesNo", "Item1", "Item0", "Sum", "%age"]]
input = input.rename(columns={"Item0": "Item2"})\
    .sort_values(by="YesNo", ascending=False)\
    .reset_index(drop=True)\
    .fillna("")

print(input.equals(test))   # True

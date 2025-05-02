import pandas as pd
import numpy as np

path = "PQ_Challenge_282.xlsx"
input1 = pd.read_excel(path, usecols="A", nrows=22, names=["Dept"])
input2 = pd.read_excel(path, usecols="C", nrows=9, names=["Dept"])
test = pd.read_excel(path, usecols="E:H", nrows=4)

input1["invalid"] = np.where(
    (input1["Dept"] == "Employees") | (input1["Dept"].shift(1) == "Employees"), 1, 0
)
input1["dept"] = np.where(input1["Dept"].isin(input2["Dept"]), input1["Dept"], np.nan)
input1["year"] = input1["Dept"].where(input1["Dept"].str.match(r"Y200[1-3]"), np.nan)

input1 = input1[input1["invalid"] == 0]
input1["dept"] = input1["dept"].ffill()
input1["year"] = input1["year"].ffill()

input1 = input1[(input1["Dept"] != input1["dept"]) & (input1["Dept"] != input1["year"])]
input1["sdept"] = input1.groupby("dept")["Dept"].transform(lambda x: x.astype(float).sum(skipna=True))

input1_pivot = input1.pivot_table(index=["dept","invalid","sdept"], columns="year", values="dept")
input1_pivot = input1_pivot.sort_values(by="sdept", ascending=False).reset_index()
input1_pivot.columns.name = None
input1_pivot = input1_pivot.drop(columns=["invalid", "sdept"])

print(input1_pivot)
import pandas as pd
import numpy as np

path = "Power Query/300-399/347/PQ_Challenge_347 - Table Decomposition.xlsx"

input1 = pd.read_excel(path, sheet_name=0, usecols="A:F", nrows=5)
input2 = pd.read_excel(path, sheet_name=0, usecols="A:B", skiprows=7, nrows=4)
test = pd.read_excel(path, sheet_name=0, usecols="I:P", nrows=20).rename(columns=lambda col: col.replace(".1", ""))

input1["ID"] = ["ID" + str(i) for i in range(1, len(input1) + 1)]
cart = input1.merge(input2, how="cross")
cart["Activity ID"] = cart["Sub Table"] + "_" + cart["ID"]
cart["Quantity"] = cart["Quantity"] * cart["%"]
cart["Total Weight"] = cart["Quantity"] * cart["Unit Weight"]

cols = [
    "Sub Table", "Activity ID", "Activity Name", "Unit", "Quantity",
    "Unit Weight", "Total Weight", "Chainage", "Resource Name"
]
result = cart[cols].sort_values("Activity ID")

subs = result.groupby("Sub Table", as_index=False)["Total Weight"].sum()
subs["Activity ID"] = "TOTAL"
for col in ["Activity Name", "Unit", "Quantity", "Unit Weight", "Chainage", "Resource Name"]:
    subs[col] = None
subs = subs[cols]

total = pd.DataFrame({
    "Activity ID": ["GRAND TOTAL"],
    "Total Weight": [result["Total Weight"].sum()],
    **{col: [None] for col in cols if col not in ["Activity ID", "Total Weight"]}
})[cols]

final = pd.concat([
    result[result["Sub Table"] == "Subtable-1"],
    subs[subs["Sub Table"] == "Subtable-1"],
    result[result["Sub Table"] == "Subtable-2"],
    subs[subs["Sub Table"] == "Subtable-2"],
    result[result["Sub Table"] == "Subtable-3"],
    subs[subs["Sub Table"] == "Subtable-3"],
    total
], ignore_index=True)[cols[1:]]

final = final.replace({np.nan: "", None: ""})
test = test.replace({np.nan: "", None: ""})
print(test)
print(final)
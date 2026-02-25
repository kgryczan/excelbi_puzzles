import numpy as np
import pandas as pd

path = "Excel/900-999/921/921 Pass Fail.xlsx"

input1 = pd.read_excel(path, usecols="A:C", nrows=16)
input2 = pd.read_excel(path, usecols="E:F", nrows=6).rename(columns=lambda c: c.rstrip(".1"))

test = pd.read_excel(path, usecols="E:G", skiprows=9, nrows=3)
test = test.rename(columns=lambda c: c.rstrip(".1")).reindex(columns=["Student", "Fail Subjects", "Pass Subjects"]).sort_values("Student").reset_index(drop=True)

merged = input1.merge(input2, on="Subject", how="left").assign(
    Pass=lambda df: np.where(df["Marks"] < df["Passing Marks"], "Fail Subjects", "Pass Subjects")
)

result = merged.pivot_table(
    index="Student",
    columns="Pass",
    values="Subject",
    aggfunc=lambda x: ", ".join(map(str, x))
).sort_values("Student").reset_index()
result.columns.name = None

print(result.equals(test))
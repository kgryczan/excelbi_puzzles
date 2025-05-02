import pandas as pd
import numpy as np

path = "PQ_Challenge_193.xlsx"

input = pd.read_excel(path, sheet_name=0, usecols="A:I", nrows=6, header=None)
test = pd.read_excel(path, sheet_name=0, usecols="A:F", skiprows=11, nrows=13)

input.iloc[0] = input.iloc[0].ffill()
input.columns = input.iloc[0] + " " + input.iloc[1]
input = input.drop([0, 1])
input = input.rename(columns={"Quarters Persons": "Persons"})

for i in range(1, 5):
    input[f"Q{i} Total"] = input.filter(like=f"Q{i}").sum(axis=1)
input["Total"] = input.filter(like="Q").sum(axis=1)

input = input.melt(id_vars=["Persons"], value_vars=input.filter(like="Q").columns, var_name="Quarter", value_name="Value")
input["Value"] = pd.to_numeric(input["Value"], errors="coerce")
input[["Quarter", "Category"]] = input["Quarter"].str.split(" ", n=1, expand=True)
input["Category"] = pd.Categorical(input["Category"], categories=["Sales", "Bonus", "Total"], ordered=True)
input = input.sort_values(["Persons", "Quarter", "Category"])
input = input.pivot_table(index=["Persons", "Category"], columns="Quarter", values="Value", aggfunc="first").reset_index()
input[["Q1", "Q2", "Q3", "Q4"]] = input.groupby("Category")[["Q1", "Q2", "Q3", "Q4"]].cumsum()
input = input.rename_axis(None, axis=1)
input["Persons"] = input.groupby("Category")["Persons"].transform(lambda x: x.cumsum().str.join(", "))
input.loc[input.index % 3 != 0, "Persons"] = np.NaN
input["Category"] = input["Category"].astype(str)

print(input.equals(test)) # True
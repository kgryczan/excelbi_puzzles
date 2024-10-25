import pandas as pd
import numpy as np

path = "573 Durations.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=12)
test = pd.read_excel(path, usecols="D:E", skiprows=1, nrows=4)
test["Duration"] = test["Duration"].apply(lambda x: round(x, 1))

input["Name"] = input["Name & Date"].apply(lambda x: x if type(x) == str else np.nan)
input["Name"] = input["Name"].ffill()
input = input.dropna(subset=["Time"]).reset_index(drop=True)

input["Time"] = input["Time"].apply(lambda x: x.strftime("%H:%M:%S"))
input["Name & Date"] = input["Name & Date"].apply(lambda x: x.strftime("%Y-%m-%d"))
input["Time"] = pd.to_datetime(input["Name & Date"] + " " + input["Time"])

input = input.drop(columns=["Name & Date"])
input["RowNumber"] = input.groupby("Name").cumcount() + 1
input = input.pivot(index="Name", columns="RowNumber", values="Time").reset_index()
input.columns.name = None
input["Duration"] = input[2] - input[1]
input["Duration"] = input["Duration"].apply(lambda x: x.total_seconds() / 3600)
input = input.drop(columns=[1, 2]).sort_values("Duration").reset_index(drop=True)

print(input.equals(test))   # True
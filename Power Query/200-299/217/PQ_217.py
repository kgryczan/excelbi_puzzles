import pandas as pd

path = "PQ_Challenge_217.xlsx"
input = pd.read_excel(path, usecols="A:H", nrows = 4)
test  = pd.read_excel(path, usecols="J:O", nrows = 7)

input.iloc[:, 2:8] = input.iloc[:, 2:8].apply(lambda x: x * input["Amt"])
input = input.drop(columns=["Amt"])

input = input.T
input.columns = input.iloc[0]
input = input.drop(input.index[0])

input["Total"] = input.sum(axis=1)
input.loc["Total"] = input.sum()
input = input.reset_index().rename(columns={"index": "Month"}).rename_axis(None, axis=1)

print(all(input == test))   # True
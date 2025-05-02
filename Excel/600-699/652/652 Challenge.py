import pandas as pd

path = "652 Generate Ticket Numbers.xlsx"

df = pd.read_excel(path, usecols="A:B", nrows=7)
# test = pd.read_excel(path, usecols="C", nrows=12)
# input["Sequence"] = input["Sequence"].str.split(", ")
# result = (
#     input.explode("Sequence")
#     .dropna()
#     .assign(rn=lambda d: d.groupby("Booklet").cumcount() + 1)
#     .sort_values(["rn", "Booklet"])
#     .drop(columns="rn")
#     .assign(**{"Answer Expected": lambda d: d["Booklet"].astype(str) + d["Sequence"].astype(str)})[["Answer Expected"]]
#     .reset_index(drop=True)
# )
# print(result.equals(test)) # True

df["Sequence"] = df["Sequence"].str.split(", ")

df = df.explode("Sequence").dropna()

df["Answer"] = df["Booklet"] + df["Sequence"]

result = df["Answer"].reset_index(drop=True)

print(result)
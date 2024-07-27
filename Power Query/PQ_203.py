import pandas as pd
import numpy as np

path = "PQ_Challenge_203.xlsx"
input = pd.read_excel(path, usecols="A:C")
test = pd.read_excel(path, usecols="E:F", nrows=4)

result = input.assign(Text=pd.to_numeric(input["Text"], errors='coerce'),
                      Group=(input["Amount1"].isna().cumsum() * ~input["Amount1"].isna())
                             .astype(int)
                             .replace(0, "Remaining"))\
                .groupby("Group") \
                .agg(lambda x: x.values.tolist())\
                .assign(nmb=lambda x: x["Text"] + x["Amount1"] + x["Amount2"])

result["nmb"] = result["nmb"].apply(lambda y: [i for i in y if not np.isnan(i)])
result["avg"] = result["nmb"].apply(lambda y: round(np.mean(y), 0)).astype("int64")

result = result.drop(columns=["Text", "Amount1", "Amount2"])\
                .rename(columns={"avg": "Avg Amount"})\
                .drop(columns="nmb")\
                .reset_index(drop=False)\
                .assign(Group=lambda x: np.select([x["Group"] == 1, x["Group"] == 2, x["Group"] == 4],
                                                 ["Group1", "Group2", "Group3"],
                                                 default=x["Group"]))

print(result.equals(test)) # True

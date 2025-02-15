import pandas as pd
import numpy as np

path = "PQ_Challenge_261.xlsx"

input = pd.read_excel(path, usecols="A:B", nrows=13)
test  = pd.read_excel(path, usecols="D:F", nrows=11)

result = input.copy()
for col in ["Country","State","Cities"]:
    result[col] = np.where(result["Data1"].eq(col), result["Data2"], np.nan)
result[["Country","State"]] = result[["Country","State"]].ffill()
result = result.drop(columns=["Data1","Data2"]).dropna(subset=["Cities"]).reset_index(drop=True)

result = (
    result.assign(Cities=result["Cities"].str.split(", "))
          .explode("Cities")
          .assign(
              Country=lambda df: df["Country"].str.strip(),
              State=lambda df: df["State"].str.strip(),
              Cities=lambda df: df["Cities"].str.strip()
          )
          .reset_index(drop=True)
)
for col in ["Country","State"]:
    result[col] = (
        result.groupby(col)[col]
              .apply(lambda x: x.where(x.index == x.index[0]))
              .droplevel(0)
    )

print(result.equals(test))

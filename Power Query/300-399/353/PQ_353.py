import pandas as pd
import numpy as np


path = "Power Query/300-399/353/PQ_Challenge_353.xlsx"
input1 = pd.read_excel(path, usecols="A:E", nrows=51)
input2 = pd.read_excel(path, usecols="G:H", nrows=4).rename(columns=lambda c: c.replace(".1", ""))
test = pd.read_excel(path, usecols="G:H", skiprows=8, nrows=5).rename(columns=lambda c: c.replace(".1", ""))

df = input1.merge(input2, on="Region")
df["capped"] = np.minimum(df["2024 Gross"] * 0.05, df["Max Bonus Cap"])
df["prosperity_tax"] = np.select(
    [df.capped < 2000, df.capped.between(2000, 3500), df.capped > 3500],
    [0, (df.capped - 2000) * 0.1, 150 + (df.capped - 3500) * 0.2]
)
df["total"] = df.capped - df.prosperity_tax + np.where(df.Dept == "Sales", 300, 0)
result = df.groupby("Region", as_index=False)["total"].sum().rename(columns={"total": "Bonus"}).sort_values("Region")
result = pd.concat([result, pd.DataFrame({"Region": ["Total"], "Bonus": [result.Bonus.sum()]})], ignore_index=True)
result["Bonus"] = result["Bonus"].astype(int)
print(result.equals(test))   # True
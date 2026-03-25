import pandas as pd

input_data = pd.read_excel("PQ_Challenge_146.xlsx", usecols="A:D", nrows=14)
test = pd.read_excel("PQ_Challenge_146.xlsx", usecols="F:I", nrows=7)

result = input_data.copy()
result["Category"] = result.apply(
    lambda r: "Equal" if r["Value"] == r["Threshold"] else ("High" if r["Value"] > r["Threshold"] else "Low"),
    axis=1,
)
result = result[result["Category"] != "Equal"].copy()
result["valid"] = result.groupby(["Group", "Category"])["Value"].transform("min")
low_mask = result["Category"] == "Low"
result.loc[low_mask, "valid"] = result.loc[low_mask].groupby(["Group", "Category"])["Value"].transform("max")
result = result[result["Value"] == result["valid"]].drop(columns=["valid", "Category"]).reset_index(drop=True)

print(result.equals(test))

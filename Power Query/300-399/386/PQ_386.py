import pandas as pd
import numpy as np

path = "300-399/386/PQ_Challenge_386.xlsx"
result = pd.read_excel(path, usecols="A", nrows=22)
test = pd.read_excel(path, usecols="C:G", nrows=22)

result[["Product", "Quantity"]] = result["Data"].str.split(r"\s\|\s", n=1, expand=True)
result["Level"] = result["Product"].str.count("-")
result["Unit Qty"] = pd.to_numeric(result["Quantity"].str.extract(r"(\d+)", expand=False), errors="coerce")
result["Root Product"] = result["Product"].where(result["Level"].eq(0)).ffill()
result["Item Name"] = result["Product"].mask(
	result["Level"].gt(0),
	result["Product"].str.replace("-", "", regex=False).str.strip(),
)
result["L1"] = result["Item Name"].where(result["Level"].eq(1)).groupby(result["Root Product"], dropna=False).ffill()
result["L2"] = result["Item Name"].where(result["Level"].eq(2)).groupby(result["L1"], dropna=False).ffill()
result["Direct Parent"] = np.select(
	[result["Level"].eq(1), result["Level"].eq(2), result["Level"].eq(3)],
	[result["Root Product"], result["L1"], result["L2"]],
	default=np.nan,
)

result = result[["Level", "Root Product", "Direct Parent", "Item Name", "Unit Qty"]]

print(result.equals(test))
import pandas as pd

input = pd.read_excel("PQ_Challenge_180.xlsx", sheet_name="Sheet1", usecols="A:B")
test = pd.read_excel("PQ_Challenge_180.xlsx", sheet_name="Sheet1", usecols="D:G", nrows=3)

result = input.copy()
result["Emp"] = result.apply(lambda row: row["Emp-Month"] if pd.isna(row["Sales"]) else None, axis=1)
result["Emp"] = result["Emp"].fillna(method="ffill")
result = result[~result["Sales"].isna()]
result["lag_sales"] = result.groupby("Emp")["Sales"].shift(1).fillna(0)
result["lag_month"] = result.groupby("Emp")["Emp-Month"].shift(1).fillna("")
result["total"] = result.groupby("Emp")["Sales"].transform("sum")
result["change"] = abs(result["lag_sales"] - result["Sales"])
max_change = result.groupby("Emp")["change"].transform("max")
result = result[result["change"] == max_change]
result = result[["Emp", "total", "change", "lag_month", "Emp-Month"]]
result.columns = ["Emp", "Total Sales", "Max Sales Change", "lag_month", "Emp-Month"]
result["From - To Months"] = result["lag_month"] + " - " + result["Emp-Month"]
result = result.drop(columns=["lag_month", "Emp-Month"])
result[["Total Sales","Max Sales Change"]] = result[["Total Sales","Max Sales Change"]].astype("int64")
result = result.reset_index(drop=True)

print(result.equals(test)) # True
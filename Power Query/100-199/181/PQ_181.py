import pandas as pd
import re

file_path = "PQ_Challenge_181.xlsx"

input = pd.read_excel(file_path, header=None, nrows=11, usecols="A:D")
test = pd.read_excel(file_path, header=0, nrows=20, usecols="F:I").sort_values(by=["Date", "Name", "Data"]).reset_index(drop=True)

result = input.copy()
result.columns = ["Name", "Data1", "Data2", "Data3"]
result["Date"] = result["Name"].apply(lambda x: x if re.search(r"\d", str(x)) else None)
result["Date"].fillna(method="ffill", inplace=True)
result = result.melt(id_vars=["Name", "Date"], var_name="Data", value_name="Value")
result["Date"] = result["Date"].apply(lambda x: pd.to_datetime(x, format="%m/%d/%Y") if re.search(r".*\d{4}$", str(x)) else pd.to_datetime(x))
result["Value"] = pd.to_numeric(result["Value"], errors="coerce")
result.dropna(inplace=True)
result = result.reset_index(drop=True)
result["Value"] = result["Value"].astype("int64")
result = result[["Date", "Name", "Data", "Value"]].sort_values(by=["Date", "Name", "Data"]).reset_index(drop=True)

print(result.equals(test)) # True
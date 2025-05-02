import pandas as pd
import re

input = pd.read_excel("PQ_Challenge_189.xlsx", usecols="A:B", nrows = 10)
test = pd.read_excel("PQ_Challenge_189.xlsx", usecols="D:F", nrows = 7)
test.columns = test.columns.str.replace(".1","")

result = input.copy()
result["Result"] = result["Code"].shift(-1).eq("Yes").replace({True: "Pass", False: pd.NA})
result["Result"] = result["Result"].fillna(result["Code"].apply(lambda x: "Fail" if re.search(r"\d", str(x)) else pd.NA))
result = result.dropna(subset=["Result"]).reset_index(drop=True)
result["Code"] = pd.to_numeric(result["Code"])

print(result.equals(test)) # True
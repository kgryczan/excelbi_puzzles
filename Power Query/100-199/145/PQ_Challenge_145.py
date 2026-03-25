import pandas as pd

input_data = pd.read_excel("PQ_Challenge_145.xlsx", usecols="A:C", nrows=16)
test = pd.read_excel("PQ_Challenge_145.xlsx", usecols="F:I", nrows=16)

result = input_data.copy()
result["Date"] = pd.to_datetime(result["Date"])
result["min_date"] = result.groupby("Store")["Date"].transform("min")
result["year"] = ((result["Date"] - result["min_date"]).dt.days / 365.25).floordiv(1).astype(int) + 1
result["Column1"] = result.groupby(["Store", "year"])["Sale"].cumsum()
result = result.drop(columns=["year", "min_date"])

print(result.equals(test))

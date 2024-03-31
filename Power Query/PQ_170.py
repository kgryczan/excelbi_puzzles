import pandas as pd

input = pd.read_excel("PQ_Challenge_170.xlsx", sheet_name="Sheet1", usecols="A:C")
test = pd.read_excel("PQ_Challenge_170.xlsx", sheet_name="Sheet1", usecols="E:H", nrows=2)

result = input.copy()
result["week_part"] = result["Date"].apply(lambda x: "Weekend" if pd.to_datetime(x).weekday() in [5, 6] else "Weekday")
result["total"] = result.groupby(["week_part", "Item"])["Sale"].transform("sum")
result["min"] = result.groupby(["week_part"])["total"].transform("min")
result["max"] = result.groupby(["week_part"])["total"].transform("max")
result["full_total"] = result.groupby(["week_part"])["Sale"].transform("sum")
result = result.drop(columns=["Date"])
result["min_max"] = result.apply(lambda row: "min" if row["total"] == row["min"] else ("max" if row["total"] == row["max"] else "none"), axis=1)
result = result[result["min_max"] != "none"].reset_index(drop=True)
result = result[["Item", "week_part", "min_max",  "full_total"]].drop_duplicates().reset_index(drop=True)
result["Item"] = result.groupby(["full_total", "min_max", "week_part"])["Item"].transform(lambda x: ", ".join(x))
result = result.drop_duplicates().reset_index(drop=True)
result = result.pivot(index=["week_part", "full_total"], columns="min_max", values="Item").reset_index()
result.columns = test.columns

print(result.equals(test)) # True
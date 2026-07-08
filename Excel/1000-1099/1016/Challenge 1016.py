import pandas as pd

path = "1000-1099/1016/1016 Shift Duration.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=12, skiprows=1)
test = pd.read_excel(path, usecols="F:H", nrows=4, skiprows=1).rename(
    columns=lambda c: __import__("re").sub(r"\.\d+$", "", c)
)

result = input.copy()
result[["Employee", "Date"]] = result[["Employee", "Date"]].ffill()
result["Duration"] = result["Duration"].where(
    result["Category"] != "Break", -result["Duration"]
)

result = (
    result.groupby(["Employee", "Date"], as_index=False)
    .agg(Duration=("Duration", "sum"))
    .sort_values(["Employee", "Date"], ascending=[False, True])
    .reset_index(drop=True)
)

print(result.equals(test))
# True

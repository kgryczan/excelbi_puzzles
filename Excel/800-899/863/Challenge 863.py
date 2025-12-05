import pandas as pd

path = "Excel/800-899/863/863 Transpose.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=12)
test = pd.read_excel(path, usecols="C:F", skiprows=1, nrows=3)

input["Date"] = input["Data"].apply(
    lambda x: pd.NA if str(x).startswith("Group") else x
).ffill()

input = input[input["Data"] != input["Date"]]
input["Group"] = input["Data"].str.extract(r"Group ([A-Z])")
input["Item"] = input["Data"].str.extract(r"Item\s*([0-9])")
input["Amount"] = input["Data"].str.extract(r"([0-9]+)$").astype("int64")

result = input.copy()
result = result.drop(columns=["Data"])
result = result.sort_values(by=["Date", "Group"])

result = (
    result.groupby("Date", as_index=False)
    .agg({
        "Group": lambda x: ", ".join(x.dropna().astype(str)),
        "Item": lambda x: ", ".join(x.dropna().astype(str)),
        "Amount": "sum"
    })
    .rename(columns={"Group": "Groups", "Item": "Items", "Amount": "Amount"})
)
print(result.equals(test)) # True
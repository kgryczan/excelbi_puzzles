import pandas as pd

path = "400-499/402/PQ_Challenge_402.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=26, skiprows=0)
test = pd.read_excel(path, usecols="D:H", nrows=16, skiprows=0)

result = input.assign(
    Category=lambda d: d.Text.where(d.LineType.eq("Category")).ffill(),
    SubCategory=lambda d: d.Text.where(d.LineType.eq("SubCategory")),
)
result["SubCategory"] = result.groupby("Category")["SubCategory"].ffill()
result = result.loc[~result["LineType"].isin(["Category", "SubCategory"])]
result[["ProductCode", "ProductName", "Price"]] = result.pop("Text").str.split(
    " - ", n=2, expand=True
)
result["Price"] = pd.to_numeric(result["Price"], errors="coerce")
result = result[
    ["ProductCode", "ProductName", "Price", "Category", "SubCategory"]
].reset_index(drop=True)

print(result.equals(test))
# True

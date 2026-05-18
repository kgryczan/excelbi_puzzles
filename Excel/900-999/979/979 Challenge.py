import pandas as pd

path = "900-999/979/979 Split and Categorize.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=9, skiprows=1)
test = pd.read_excel(path, usecols="D:F", nrows=14, skiprows=1).rename(
	columns=lambda c: c.replace(".1", "")
)

result = input.assign(Items=input["Items"].str.split(", ")).explode("Items", ignore_index=True)
first = result.groupby("Category").cumcount().eq(0)
all_items = result.groupby("Category")["Items"].transform(
	lambda s: ", ".join(s.dropna().astype(str))
)
result = result.assign(
	Category=result["Category"].where(first),
	**{
		"All Items": all_items.where(first),
		"Individual Items": result["Items"],
	},
)[["Category", "All Items", "Individual Items"]]

print(result.equals(test))
# True
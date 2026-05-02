import pandas as pd

path = "300-399/387/PQ_Challenge_387.xlsx"
input_df = pd.read_excel(path, usecols="A", nrows=16, skiprows=0)
test = pd.read_excel(path, usecols="C:G", nrows=5, skiprows=0)

result = (
	input_df.iloc[:, 0]
	.str.split(r" \| ", expand=True, n=3)
	.set_axis(["order", "priority", "items", "discount"], axis=1)
	.assign(
		priority=lambda d: d["priority"].str.extract(r"Priority:([A-Za-z]+)"),
		items=lambda d: d["items"].str.findall(r"\[(.+?)\]"),
		discount=lambda d: pd.to_numeric(d["discount"].str.extract(r"(\d+)", expand=False), errors="coerce").fillna(0),
	)
	.explode("items")
)
result[["SKU", "quantity", "unit_price"]] = result.pop("items").str.split(":", expand=True, n=2)
result = (
	result.assign(
		quantity=lambda d: pd.to_numeric(d["quantity"]),
		unit_price=lambda d: pd.to_numeric(d["unit_price"]),
		Sales=lambda d: d["quantity"] * d["unit_price"] * (1 - d["discount"] / 100),
	)
	.groupby(["SKU", "priority"], as_index=False)["Sales"].sum().round(2)
	.pivot(index="SKU", columns="priority", values="Sales")
	.reindex(columns=["High", "Medium", "Low"], fill_value=0)
	.fillna(0)
	.reset_index()
)
result["Total"] = result[["High", "Medium", "Low"]].sum(1)

print(result.equals(test))
# discrepancies of rounding in High column


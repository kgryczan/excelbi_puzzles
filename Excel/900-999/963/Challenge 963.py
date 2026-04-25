import pandas as pd

path = "900-999/963/963 Active Engaged Customers.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=41, skiprows=1)
test = pd.read_excel(path, usecols="D:F", nrows=30, skiprows=1)

input["ActivityDate"] = pd.to_datetime(input["ActivityDate"])
daily = (
	input[["CustomerID", "ActivityDate"]]
	.drop_duplicates()
	.groupby("ActivityDate", as_index=False)["CustomerID"]
	.agg(list)
	.sort_values("ActivityDate")
)
active = []
engaged = []
for current_date in daily["ActivityDate"]:
	window = daily.loc[
		daily["ActivityDate"].between(
			current_date - pd.Timedelta(days=29), current_date
		),
		"CustomerID",
	]
	customers = [customer for group in window for customer in group]
	counts = pd.Series(customers).value_counts()
	active.append(len(counts))
	engaged.append((counts >= 3).sum())
result = pd.DataFrame(
	{
		"Date": daily["ActivityDate"].dt.strftime("%Y-%m-%d").str.replace(
			"-", "‑", regex=False
		),
		"Active": active,
		"Engaged": engaged,
	}
)

print(result.equals(test))
# True
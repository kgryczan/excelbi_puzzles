import pandas as pd

path = "900-999/970/970 Resolution Time.xlsx"
input_df = pd.read_excel(path, usecols="A", skiprows=1, nrows=31, header=None)
test = pd.read_excel(path, usecols="C:D", skiprows=1, nrows=7)

result = input_df[0].str.split(",", expand=True)
result.columns = result.iloc[0]
result = result.iloc[1:].copy()

result["ChangeTime"] = pd.to_datetime(
	result["ChangeTime"], format="%m/%d/%Y %I:%M:%S %p"
)
result = result.sort_values(["TicketID", "ChangeTime"])
result["diff"] = (
	result.groupby("TicketID")["ChangeTime"].shift(-1) - result["ChangeTime"]
).dt.total_seconds() / 60
result = (
	result.loc[
		~result["Status"].isin(["Pending Customer", "On Hold", "Closed"])
	]
	.groupby("TicketID", as_index=False)["diff"]
	.sum(min_count=1)
	.fillna({"diff": 0})
	.astype({"diff": "int64"})
	.rename(columns={"diff": "ResolutionMinutes"})
)
print(result.equals(test))
# True
import pandas as pd

path = "900-999/989/989 Chain Calculation.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=25, skiprows=1)
test = pd.read_excel(path, usecols="E:H", nrows=3, skiprows=1).rename(columns=lambda c: c.replace(".1", "") if isinstance(c, str) else c)

df = input.copy()
df["Timestamp"] = pd.to_datetime(df["Timestamp"])
df["Time_diff"] = df.groupby("User", sort=False)["Timestamp"].diff().dt.total_seconds().div(60)
df["Chain"] = (
	df["Time_diff"].isna() | df["Time_diff"].gt(10)
).groupby(df["User"], sort=False).cumsum()

summary = (
	df.groupby(["User", "Chain"], sort=False)
	.agg(
		**{
			"Chain Start": ("Timestamp", "min"),
			"Chain End": ("Timestamp", "max"),
			"Chain Total Value": ("Value", "sum"),
		}
	)
	.reset_index()
)

result = summary.loc[
	summary.groupby("User", sort=False)["Chain Total Value"].transform("max")
	== summary["Chain Total Value"]
].drop(columns="Chain").reset_index(drop=True)

print(result.equals(test))
# True
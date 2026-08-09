import pandas as pd

path = "400-499/416/PQ_Challenge_416.xlsx"
campaigns = pd.read_excel(path, sheet_name="Sheet1", usecols="A:E").dropna()
holidays = pd.read_excel(path, sheet_name="Sheet1", usecols="G:H").dropna()
rules = pd.read_excel(path, sheet_name="Sheet1", usecols="G:I", skiprows=4, nrows=3)
test = pd.read_excel(path, sheet_name="Sheet1", usecols="K:N")
test.columns = ["Campaign ID", "Department", "Date", "Daily Allocation"]

days = dict(zip("Mon Tue Wed Thu Fri Sat Sun".split(), range(7)))
result = pd.concat(
    [
        pd.DataFrame(
            {
                "Campaign ID": c["Campaign ID"],
                "Department": c.Department,
                "Date": pd.date_range(c["Start Date"], c["End Date"]),
                "Total Budget": c["Total Budget"],
            }
        )
        for _, c in campaigns.iterrows()
    ],
    ignore_index=True,
).merge(rules, on="Department")
result = (
    result.loc[
        result.Date.dt.dayofweek.between(
            result["From Day"].map(days), result["To Day"].map(days)
        )
        & ~result.Date.isin(holidays["Holiday Date"])
    ]
    .assign(
        **{
            "Daily Allocation": lambda x: x["Total Budget"]
            / x.groupby("Campaign ID")["Date"].transform("size")
        }
    )
    .loc[:, ["Campaign ID", "Department", "Date", "Daily Allocation"]]
    .reset_index(drop=True)
    .astype({"Daily Allocation": int})
)
print(result.equals(test))

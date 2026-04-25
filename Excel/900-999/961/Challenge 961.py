import pandas as pd

path = "900-999/961/961 Monthly Rent Calculation.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=21, skiprows=1)
test = pd.read_excel(path, usecols="F:G", nrows=24, skiprows=1)

df = input.copy()
df["StartDate"] = pd.to_datetime(df["StartDate"])
df["EndDate"] = pd.to_datetime(df["EndDate"])
rows = []
for _, r in df.iterrows():
    start_date = r["StartDate"]
    end_date = r["EndDate"]
    rent = r["MonthlyRent"]

    if pd.isna(start_date) or pd.isna(end_date):
        continue

    month_seq = pd.date_range(
        start=start_date.to_period("M").to_timestamp(),
        end=end_date.to_period("M").to_timestamp(),
        freq="MS",
    )

    for month_start in month_seq:
        month_end = month_start + pd.offsets.MonthEnd(1)
        days_in_month = month_end.day

        overlap_start = max(start_date, month_start)
        overlap_end = min(end_date, month_end)
        overlap_days = max((overlap_end - overlap_start).days + 1, 0)

        rows.append(
            {
                "YearMonth": month_start.strftime("%Y-%m"),
                "total_rent": rent / days_in_month * overlap_days,
            }
        )
result = (
	pd.DataFrame(rows)
	.groupby("YearMonth", as_index=False)["total_rent"]
	.sum()
)
result["total_rent"] = result["total_rent"].round(0).astype("int64")
result.columns = test.columns
print(result.equals(test))
# True
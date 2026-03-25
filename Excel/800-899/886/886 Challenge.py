import pandas as pd

path = "800-899/886/886 Invoice Due Date Calculation.xlsx"
input_df = pd.read_excel(path, usecols="A:D", nrows=39)
test = pd.read_excel(path, usecols="E", nrows=39)

pay_days = {"A": 30, "B": 45, "C": 60}


def next_monday(dt):
    if dt.weekday() == 5:
        return dt + pd.Timedelta(days=2)
    if dt.weekday() == 6:
        return dt + pd.Timedelta(days=1)
    return dt


def first_workday_of_next_month(dt):
    return next_monday(dt.to_period("M").to_timestamp() + pd.offsets.MonthBegin(1))


def assign_due_dates(df):
    out = []
    for category, grp in df.sort_values(["Category", "Invoice_Date", "Invoice_ID"]).groupby("Category", sort=False):
        month_counts = {}
        for row in grp.itertuples(index=False):
            due = next_monday(row.Invoice_Date + pd.Timedelta(days=pay_days[category]))
            while month_counts.get(due.to_period("M"), 0) >= 2:
                due = first_workday_of_next_month(due)
            month_counts[due.to_period("M")] = month_counts.get(due.to_period("M"), 0) + 1
            out.append((row.Invoice_ID, due))
    return pd.DataFrame(out, columns=["Invoice_ID", "Due_date"])


result = (
    assign_due_dates(input_df)
    .sort_values("Invoice_ID")
    .reset_index(drop=True)
)

print(result["Due_date"].equals(test["Answer Expected"]))
# True

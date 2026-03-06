import pandas as pd

path = "900-999/928/928 Summarize Status Hours.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=26)
test = pd.read_excel(path, usecols="C:D", skiprows=1, nrows=5)

result = (
    input
    .assign(
        Status=lambda d: d["Data"].str.extract(r'(Completed|In-Progress|On-Hold|Pending)'),
        Hours=lambda d: d["Data"].str.extract(r'(\d{1,3}(?:\.\d+)?)(?=\D*$)').astype(float)
    )
    .groupby("Status", as_index=False)["Hours"]
    .sum()
)
result = pd.concat(
    [result, pd.DataFrame({"Status": ["Total"], "Hours": [result["Hours"].sum()]})],
    ignore_index=True
)
result = result.rename(columns={"Hours": "Total Hours"})

print(result.equals(test))
# True
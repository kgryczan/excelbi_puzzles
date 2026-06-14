import pandas as pd

path = "400-499/400/PQ_Challenge_400.xlsx"
input = pd.read_excel(path, usecols="A", nrows=12)
test = pd.read_excel(path, usecols="C:F", nrows=14)

priority = {"Blocked": 1, "Review": 2, "Open": 3, "Closed": 4}

parts = input["Event"].str.split(",", expand=True)
result = (
    input.assign(
        Entity=parts[0].str.strip(),
        StartDate=pd.to_datetime(parts[1].str.strip(), dayfirst=True, errors="coerce"),
        EndDate=pd.to_datetime(parts[2].str.strip(), dayfirst=True, errors="coerce"),
        Status=parts[3].str.strip(),
    )
    .drop(columns="Event")
    .dropna(subset=["StartDate", "EndDate"])
    .assign(
        StatusRank=lambda d: d["Status"].map(priority),
        Date=lambda d: d.apply(
            lambda r: pd.date_range(r["StartDate"], r["EndDate"], freq="D"), axis=1
        ),
    )
    .explode("Date")
    .sort_values(["StatusRank", "Entity", "Date"])
    .drop_duplicates(["Entity", "Date"])
    .sort_values(["Entity", "Date"])
    .assign(
        grp=lambda d: d.groupby("Entity")["Status"].transform(
            lambda s: s.ne(s.shift()).cumsum()
        )
    )
    .groupby(["Entity", "grp"], sort=False, as_index=False)
    .agg(
        StartDate=("Date", "min"),
        EndDate=("Date", "max"),
        FinalStatus=("Status", "first"),
    )
    .drop(columns="grp")
)

print(result.equals(test))

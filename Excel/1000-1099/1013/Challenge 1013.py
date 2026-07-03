import pandas as pd

path = "1000-1099/1013/1013 Responsibilities Allocation.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=18, skiprows=1)
test = pd.read_excel(path, usecols="F:G", nrows=5, skiprows=1).rename(
    columns=lambda c: __import__("re").sub(r"\.\d+$", "", c)
)

result = (
    input[["Employee"]]
    .drop_duplicates()
    .merge(
        input.assign(
            resp_ass=input["Event"].map({"Assign": 1, "Release": -1}).fillna(0)
        )
        .groupby(["Employee", "Reason"])["resp_ass"]
        .sum()
        .reset_index()
        .rename(columns={"resp_ass": "total_resp_ass"})
        .query("total_resp_ass > 0")
        .groupby("Employee")["Reason"]
        .apply(lambda x: ", ".join(x))
        .reset_index()
        .rename(columns={"Reason": "Responsibilities"}),
        on="Employee",
        how="left",
    )
    .assign(Responsibilities=lambda d: d["Responsibilities"])
    .sort_values("Employee")
    .reset_index(drop=True)
)

print(result.equals(test))
# True

import pandas as pd

path = "900-999/998/998 Extraction.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=18, skiprows=1)
test = pd.read_excel(path, usecols="D:G", nrows=5, skiprows=1).rename(
    columns=lambda c: c.removesuffix(".1")
)
result = (
    input.assign(
        Configuration=lambda d: d["RevisionLog"].str.extract(r"CFG:([^|]+)"),
        Revision=lambda d: d["RevisionLog"].str.extract(r"REV:(\d+)").astype(int),
        Status=lambda d: d["RevisionLog"].str.extract(r"STS:([^}]+)"),
    )
    .assign(rank=lambda d: d["Status"].map({"FINAL": 1, "REVIEW": 2}).fillna(3))
    .sort_values(["TicketID", "rank", "Revision"], ascending=[True, True, False])
    .drop_duplicates("TicketID")
    .reset_index(drop=True)[["TicketID", "Configuration", "Revision", "Status"]]
)

print(result.equals(test))
# True

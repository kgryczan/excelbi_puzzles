import pandas as pd

path = "400-499/420/PQ_Challenge_420.xlsx"
input = pd.read_excel(path, usecols="A:D").assign(Row=lambda x: range(len(x)))
test = pd.read_excel(path, usecols="F:I")
test.columns = ["Customer", "Snapshot", "Service", "Value"]
test = test.dropna(subset=["Customer"])
test = test.astype({"Snapshot": "int64", "Value": "int64"})
input["Snapshot"] = input.Event.eq("SNAPSHOT").groupby(input.Customer).cumsum()

snapshots = input.query("Event == 'SNAPSHOT'").rename(columns={"Row": "SnapshotRow"})[
    ["Customer", "Snapshot", "SnapshotRow"]
]
changes = input.query("Event != 'SNAPSHOT'")[
    ["Customer", "Service", "Value", "Event", "Row"]
]
result = (
    snapshots.merge(changes, on="Customer")
    .query("Row < SnapshotRow")
    .sort_values(["SnapshotRow", "Row"])
    .drop_duplicates(["Customer", "Snapshot", "Service"], keep="last")
    .query("Event == 'ADD'")
    .sort_values(["SnapshotRow", "Row"])[["Customer", "Snapshot", "Service", "Value"]]
    .reset_index(drop=True)
    .astype({"Snapshot": "int64", "Value": "int64"})
)

print(result.equals(test.reset_index(drop=True)))

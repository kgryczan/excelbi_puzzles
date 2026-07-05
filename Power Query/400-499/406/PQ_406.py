import pandas as pd

path = "400-499/406/PQ_Challenge_406.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=21)
test = pd.read_excel(path, usecols="F:J", nrows=9).rename(
    columns=lambda x: x.replace(".1", "")
)

df = input.copy()
df["Timestamp"] = pd.to_datetime(df["Timestamp"].astype(str))
df = df.sort_values("Timestamp")
new_combo = (
    df["Player"].shift().isna()
    | (df["Player"] != df["Player"].shift())
    | ((df["Timestamp"] - df["Timestamp"].shift()).dt.total_seconds() > 5)
    | (df["Points"] < df["Points"].shift())
)
df["combo_id"] = new_combo.cumsum()
result = (
    df.groupby("combo_id", as_index=False)
    .agg(
        Player=("Player", "first"),
        ComboStart=("Timestamp", "first"),
        ComboEnd=("Timestamp", "last"),
        TotalMoves=("Move", "size"),
        TotalPoints=("Points", "sum"),
    )
    .drop(columns="combo_id")
)
result["ComboStart"] = result["ComboStart"].dt.time
result["ComboEnd"] = result["ComboEnd"].dt.time

print(result.equals(test))
# True

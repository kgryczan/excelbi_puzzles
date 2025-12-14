import pandas as pd

excel_path = "Power Query/300-399/348/PQ_Challenge_348.xlsx"
input = pd.read_excel(excel_path, header=None, usecols="A", nrows=96)
test = pd.read_excel(excel_path, usecols="C:H", nrows=45)

df = input.iloc[:, 0].str.split(",", expand=True)
df.columns = df.iloc[0]
df = df.iloc[1:].reset_index(drop=True)
df["Timestamp"] = pd.to_datetime(
    df["Timestamp"].str.strip().str.replace("T", " ").str.replace("Z", "").str[:19],
    format="%Y-%m-%d %H:%M:%S",
)
df = df.sort_values(["UserID", "Timestamp"]).reset_index(drop=True)
df["delta_secs"] = df.groupby("UserID")["Timestamp"].diff().dt.total_seconds().fillna(0)
df["SessionID"] = (df["delta_secs"] > 1800).groupby(df["UserID"]).cumsum() + 1

result = (
    df.groupby(["UserID", "SessionID"], as_index=False)
    .agg(
        StartTime=("Timestamp", "min"),
        EndTime=("Timestamp", "max"),
        PageCount=("Timestamp", "count"),
        Duration=("Timestamp", lambda x: (x.max() - x.min()).total_seconds() / 60),
    )
    .sort_values(["UserID", "SessionID"])
    .reset_index(drop=True)
)
result["Duration"] = result["Duration"].astype("int64")
test["Duration"] = test["Duration"].astype("int64")

print(result.equals(test))
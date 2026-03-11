import pandas as pd
from datetime import datetime

path = "900-999/930/930 Start Stop RunTime.xlsx"

input = pd.read_excel(path, skiprows=1, usecols="A:C", nrows=20)
test = pd.read_excel(path, skiprows=1, usecols="E:H", nrows=11).rename(columns=lambda c: c.rstrip(".1"))

result = (
    input
    .assign(rn=lambda df: df.groupby(["Machine", "EventType"]).cumcount())
    .pivot(index=["Machine", "rn"], columns="EventType", values="EventTime")
    .reset_index()
    .sort_values(["Machine", "rn"])
    .assign(
        Stop=lambda df: df["Stop"].fillna(datetime(2024, 3, 1, 18, 0, 0)),
        RunMinutes=lambda df: ((df["Stop"] - df["Start"]).dt.total_seconds() / 60).astype("int64"),
    )
    .rename(columns={"Start": "StartTime", "Stop": "StopTime"})
    [["Machine", "StartTime", "StopTime", "RunMinutes"]]
    .reset_index(drop=True)
)

print(result.equals(test))
# True


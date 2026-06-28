import pandas as pd
from datetime import datetime, timedelta

path = "400-499/404/PQ_Challenge_404.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=21)
test = pd.read_excel(path, usecols="E:G", nrows=7)

result = input.copy()
result["Pay_Profile"] = pd.to_numeric(
    result["Pay_Profile"].str.extract(r"Base:(\d+)\/hr")[0], errors="coerce"
)
result = result.assign(Shift_Data=result["Shift_Data"].str.split("|")).explode(
    "Shift_Data", ignore_index=True
)
result[["Start_Time", "End_Time", "Break_Mins"]] = result["Shift_Data"].str.extract(
    r"^[A-Z]{3}:(\d{2}:\d{2})-(\d{2}:\d{2})\[(\d+)B\]$"
)
result["Break_Mins"] = pd.to_numeric(result["Break_Mins"], errors="coerce")
result["Start_Time"] = pd.to_datetime(
    result["Start_Time"], format="%H:%M", errors="coerce"
).dt.time
result["End_Time"] = pd.to_datetime(
    result["End_Time"], format="%H:%M", errors="coerce"
).dt.time


def shift_mins(start, end, break_mins=0):
    fmt = "%H:%M"
    start_time = datetime.strptime(start, fmt)
    end_time = datetime.strptime(end, fmt)
    if end_time < start_time:
        end_time += timedelta(days=1)
    duration = end_time - start_time - timedelta(minutes=break_mins)
    return int(duration.total_seconds() / 60)


result["Shift_Duration"] = (
    result.apply(
        lambda row: shift_mins(
            row["Start_Time"].strftime("%H:%M"),
            row["End_Time"].strftime("%H:%M"),
            row["Break_Mins"],
        ),
        axis=1,
    )
    / 60
)
summary = (
    result.groupby("Emp_ID")
    .agg(
        Total_Hours_Worked=pd.NamedAgg(column="Shift_Duration", aggfunc="sum"),
        Pay_Profile=pd.NamedAgg(column="Pay_Profile", aggfunc="first"),
    )
    .reset_index()
)
summary["Total_Pay"] = summary.apply(
    lambda row: row["Pay_Profile"] * min(row["Total_Hours_Worked"], 40)
    + row["Pay_Profile"] * 1.5 * max(row["Total_Hours_Worked"] - 40, 0),
    axis=1,
).round(2)
summary = summary.drop(columns=["Pay_Profile"])
summary.columns = test.columns

print(summary.equals(test))
# True

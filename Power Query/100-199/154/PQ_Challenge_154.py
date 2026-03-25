import pandas as pd

input_data = pd.read_excel("PQ_Challenge_154.xlsx", usecols="A:C", nrows=10)
input_data.columns = [c.strip().lower() for c in input_data.columns]
test = pd.read_excel("PQ_Challenge_154.xlsx", usecols="E:I", nrows=23)
test.columns = [c.strip().lower() for c in test.columns]

fly = input_data.copy()
rest = input_data.copy()
rest["prev_end"] = rest.groupby("pilot")["flight_end"].shift()
rest = rest.dropna(subset=["prev_end"])[["pilot", "prev_end", "flight_start"]].rename(columns={"prev_end": "rest_start", "flight_start": "rest_end"})

def split_months(start, end):
    points = [start]
    current = pd.Timestamp(start).replace(day=1) + pd.offsets.MonthBegin(1)
    while current < end:
        points.append(current)
        current = current + pd.offsets.MonthBegin(1)
    points.append(end)
    return pd.DataFrame({"start": points[:-1], "end": points[1:]})

fly_parts = []
for _, row in fly.iterrows():
    part = split_months(row["flight_start"], row["flight_end"])
    part["pilot"] = row["pilot"]
    part["mode"] = "fly"
    fly_parts.append(part)
rest_parts = []
for _, row in rest.iterrows():
    part = split_months(row["rest_start"], row["rest_end"])
    part["pilot"] = row["pilot"]
    part["mode"] = "rest"
    rest_parts.append(part)

result = pd.concat(fly_parts + rest_parts, ignore_index=True)
result["month"] = pd.to_datetime(result["start"]).dt.month
result["year"] = pd.to_datetime(result["start"]).dt.year
result["duration"] = (pd.to_datetime(result["end"]) - pd.to_datetime(result["start"])).dt.total_seconds() / 3600
result = result.groupby(["pilot", "mode", "month", "year"], as_index=False)["duration"].sum()
result["duration"] = result["duration"].round(2)
result = result.pivot(index=["pilot", "month", "year"], columns="mode", values="duration").fillna(0).reset_index()
result.columns.name = None
result = result.rename(columns={"fly": "fly_time", "rest": "rest_time"})
result = result.merge(test, on=["pilot", "year", "month"], how="left", suffixes=("", "_test"))
result["check_fly"] = result["fly_time"] == result["fly_time_test"]
result["check_rest"] = result["rest_time"] == result["rest_time_test"]

print(result.equals(test.assign(check_fly=True, check_rest=True)))

import pandas as pd

test = pd.read_excel("PQ_Challenge_151.xlsx", usecols="G:H", nrows=6)
test.columns = [c.strip().lower() for c in test.columns]

def read_range(path, usecols, skiprows, nrows):
    df = pd.read_excel(path, usecols=usecols, skiprows=skiprows, nrows=nrows)
    df.columns = [c.strip().lower().replace(" ", "_") for c in df.columns]
    return df

input1 = read_range("PQ_Challenge_151.xlsx", "A:E", 0, 6)
input2 = read_range("PQ_Challenge_151.xlsx", "A:D", 8, 6)

input1["start"] = pd.to_datetime(input1["start_date"]) + pd.to_timedelta(input1["start_time"].astype(str))
input1["end"] = pd.to_datetime(input1["end_date"]) + pd.to_timedelta(input1["end_time"].astype(str))

rows = []
for _, row in input1.iterrows():
    rng = pd.date_range(row["start"], row["end"], freq="H")
    for dt in rng:
        rows.append({"employee": row["employee"], "start": row["start"], "end": row["end"], "datetime": dt})
result = pd.DataFrame(rows)
result["weekday"] = result["datetime"].dt.weekday + 1
result["time"] = result["datetime"].dt.time
input2["start_time"] = pd.to_timedelta(input2["start_time"].astype(str))
input2["end_time"] = pd.to_timedelta(input2["end_time"].astype(str))
result["time_td"] = pd.to_timedelta(result["time"].astype(str))
result = result.merge(input2, on="weekday", how="left")
result = result[(result["datetime"] >= result["start"]) & (result["datetime"] <= result["end"]) & (result["time_td"] >= result["start_time"]) & (result["time_td"] < result["end_time"])]
result = result.groupby("employee", as_index=False).size().rename(columns={"size": "total_hours"})

print(result.equals(test))

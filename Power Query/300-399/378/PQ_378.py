import pandas as pd

path = "300-399/378/PQ_Challenge_378.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=20)
test = pd.read_excel(path, usecols="G:K", nrows=4).rename(columns=lambda c: c.replace(".1", ""))

time_str = input["Time"].astype(str)
t = pd.to_datetime(time_str, format="%H:%M:%S", errors="coerce")
t = t.fillna(pd.to_datetime(time_str, format="%H:%M", errors="coerce"))

if "Date" in input.columns:
    input["Time"] = pd.to_datetime(input["Date"].astype(str) + " " + t.dt.time.astype(str), errors="coerce")
else:
    input["Time"] = t

result = (
    input.sort_values(["Employee", "Time"])
      .assign(SessionID=lambda x: x.groupby("Employee")["EventType"]
                                .transform(lambda s: (s == "Login").cumsum()))
      .assign(
          next_time=lambda x: x.groupby(["Employee", "SessionID"])["Time"].shift(-1),
          active=lambda x: (
              (x["EventType"].isin(["Login", "Unlock"])) *
              (x["next_time"] - x["Time"]).dt.total_seconds() / 60
          ).fillna(0)
      )
      .groupby(["Employee", "SessionID"], as_index=False)
      .agg(
          StartTime=("Time", "first"),
          EndTime=("Time", "last"),
          ActiveMinutes=("active", "sum")
      )
      .sort_values(['SessionID', 'Employee'])
      .reset_index(drop=True)
)

result['ActiveMinutes'] = result['ActiveMinutes'].round().astype('Int64')
result['StartTime'] = result['StartTime'].dt.time
result['EndTime'] = result['EndTime'].dt.time

print((result == test).all().all())
# True
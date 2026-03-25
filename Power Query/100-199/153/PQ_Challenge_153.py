import pandas as pd

input_data = pd.read_excel("PQ_Challenge_153.xlsx", usecols="A:C", nrows=13)
input_data.columns = [c.strip().lower() for c in input_data.columns]
test = pd.read_excel("PQ_Challenge_153.xlsx", usecols="E:G", nrows=5)
test.columns = [c.strip().lower() for c in test.columns]

result = input_data.copy()
result["prev_landing"] = result.groupby("pilot")["flight_end"].shift()
result["flight_time"] = result["flight_end"] - result["flight_start"]
result["rest_time"] = result["flight_start"] - result["prev_landing"]
result = result.groupby("pilot", as_index=False).agg(fly_time=("flight_time", "sum"), rest_time=("rest_time", "sum"))
result["fly_time"] = result["fly_time"].dt.total_seconds().div(3600).round(2)
result["rest_time"] = result["rest_time"].dt.total_seconds().div(3600).round(2)
result["fly_time"] = result["fly_time"].where(result["fly_time"] != 0)
result["rest_time"] = result["rest_time"].where(result["rest_time"] != 0)

print(result.equals(test))

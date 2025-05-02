import pandas as pd
from datetime import datetime

path = "489 Total Time in a Week.xlsx"
input = pd.read_excel(path,  usecols="A:H", skiprows=1)
test = pd.read_excel(path, usecols="J:K", skiprows=1)

result = input.melt(id_vars=["Time Period"], var_name="wday", value_name="Name")
result[["start", "end"]] = result["Time Period"].str.split(" - ", expand=True)
result["start"] = pd.to_datetime(result["start"], format="%H:%M").dt.strftime("%H:%M")
result["end"] = pd.to_datetime(result["end"], format="%H:%M").dt.strftime("%H:%M")
result["duration"] = (pd.to_datetime(result["end"]) - pd.to_datetime(result["start"])).dt.total_seconds() / 3600
result = result.dropna().groupby("Name").agg({"duration": "sum"}).\
    rename(columns={"duration": "Total Hours"}).sort_values("Name").reset_index()
test = test.sort_values("Name").reset_index(drop=True)

print(result.equals(test)) # True
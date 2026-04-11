from boto3 import session
from argparse import Action
import pandas as pd


path = "300-399/381/PQ_Challenge_381.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=26).sort_values(["User", "Time"])
test = pd.read_excel(path, usecols="E:I", nrows=5)
thr = 45

result = input.copy().sort_values(["User", "Time"]).reset_index(drop=True)
result["Time"] = pd.to_datetime(result["Time"].astype(str))
result["logins"] = result["Action"].eq("Login").astype(int).cumsum()
grp = ["User", "logins"]

result["diff"] = result.groupby(grp)["Time"].diff().dt.total_seconds().div(60)
result["LI_ts"] = result["Time"].where(result["Action"].eq("Login")).groupby([result["User"], result["logins"]]).transform("first")
result["LO_ts"] = result["Time"].where(result["Action"].eq("Logout")).groupby([result["User"], result["logins"]]).transform("first")
first_gap_time = result["Time"].where(result["diff"].gt(thr)).groupby([result["User"], result["logins"]]).transform("min")
result["session_end"] = pd.concat([first_gap_time, result["LO_ts"]], axis=1).min(axis=1)

result = result[result["Time"].between(result["LI_ts"], result["session_end"])].copy()
last_diff = result.groupby(grp)["diff"].transform("last")
prev_time_last = result.groupby(grp)["Time"].shift(1).groupby([result["User"], result["logins"]]).transform("last")
result["session_end_adj"] = result["session_end"].where(~last_diff.ge(thr), prev_time_last + pd.Timedelta(minutes=thr))
result["duration"] = (result["session_end_adj"] - result["LI_ts"]).dt.total_seconds() / 60

result = (
	result.assign(LI=result["LI_ts"].dt.time, session_end_adj=result["session_end_adj"].dt.time)
	[["User", "LI", "session_end_adj", "duration"]]
	.drop_duplicates()
	.reset_index(drop=True)
)
result["session_number"] = result.groupby("User").cumcount() + 1
result = result[["User", "session_number", "LI", "session_end_adj", "duration"]]
result.columns = test.columns

print(result == test)
# Session C1 wrong end. 
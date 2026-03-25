import pandas as pd

input_data = pd.read_excel("PQ_Challenge_150.xlsx", usecols="A:D", nrows=11)
input_data.columns = [c.strip().lower() for c in input_data.columns]
test = pd.read_excel("PQ_Challenge_150.xlsx", usecols="F:I", nrows=11)
test.columns = [c.strip().lower() for c in test.columns]

result = input_data.copy()
result["empty"] = result["time_in"].isna()
result["nr"] = result.groupby("empty").cumcount() + 1

def fill_pair(group):
    group = group.copy()
    if group["empty"].iloc[0]:
        group["time_in"] = group["time_out"].iloc[0]
        group["time_out"] = group["time_in"] + pd.to_timedelta(round(group["duration"].iloc[0] * 60), unit="m")
    return group

result = result.groupby("nr", group_keys=False).apply(fill_pair).drop(columns=["empty", "nr"]).reset_index(drop=True)
print(result.equals(test))

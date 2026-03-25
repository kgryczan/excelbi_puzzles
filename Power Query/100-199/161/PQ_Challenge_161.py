import pandas as pd

input_data = pd.read_excel("PQ_Challenge_161.xlsx", usecols="A:C", nrows=30)
input_data.columns = [c.strip().lower() for c in input_data.columns]
test = pd.read_excel("PQ_Challenge_161.xlsx", usecols="E:H", nrows=30)
test.columns = [c.strip().lower() for c in test.columns]

def find_mode(values):
    values = pd.Series(values).dropna()
    if values.empty:
        return None
    counts = values.value_counts()
    top = counts.max()
    return ", ".join(str(v) for v in sorted(counts[counts == top].index))

df = input_data.copy()
df["group_min_week"] = df.groupby("group")["week_no"].transform("min")
df["week_start_date"] = pd.to_datetime(df["week_no"].astype(str) + "1", format="%Y%U%w")
for i in range(8):
    df[f"WM{i}"] = df["week_start_date"] - pd.to_timedelta(7 * i, unit="D")

long = df.melt(id_vars=["group", "group_min_week", "week_no"], value_vars=[f"WM{i}" for i in range(8)], var_name="week_marker", value_name="valid_week_start")
long["group_min_week"] = pd.to_datetime(long["group_min_week"].astype(str) + "1", format="%Y%U%w")
inp2 = input_data.copy()
inp2["week_start_date"] = pd.to_datetime(inp2["week_no"].astype(str) + "1", format="%Y%U%w")
joined = long.merge(inp2, left_on=["group", "valid_week_start"], right_on=["group", "week_start_date"], how="left")
joined = joined[joined["valid_week_start"] >= joined["group_min_week"]]
joined["no_groups"] = joined.groupby(["group", "week_no_x"])["winning_no"].transform("size")
agg = joined.groupby(["group", "week_no_x", "no_groups"], as_index=False).agg(winning_nos=("winning_no", list))
agg["mode"] = agg["winning_nos"].map(find_mode)
agg["mode"] = agg["mode"].where(agg["no_groups"] >= 8)
result = input_data.merge(agg[["group", "week_no_x", "mode"]], left_on=["group", "week_no"], right_on=["group", "week_no_x"], how="left").drop(columns="week_no_x")

check = result.merge(test, on=["group", "week_no"], how="left")
check["check"] = check["mode"] == check["max_occurred_no"]
print(check[["group", "week_no", "mode", "max_occurred_no", "check"]])

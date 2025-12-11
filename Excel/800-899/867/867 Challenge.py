import pandas as pd

path = "Excel/800-899/867/867 Longest Streak.xlsx"

input = pd.read_excel(path, usecols="A:G", nrows=100, skiprows=0)
test = pd.read_excel(path, usecols="I:J", nrows=6, skiprows=0)

df = input.sort_values("Rep")
df["goal_achieved"] = df["Revenue"] > df["Target"]
df["c"] = df.groupby("Rep")["goal_achieved"].transform(lambda x: (~x).cumsum())
streaks = df.groupby(["Rep", "c"]).size().reset_index(name="streak")
result = streaks.groupby("Rep")["streak"].max().reset_index(name="longest_streak")
result = result.sort_values("longest_streak", ascending=False).reset_index(drop=True)

print(result)
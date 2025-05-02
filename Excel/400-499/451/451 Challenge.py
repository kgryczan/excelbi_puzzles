import pandas as pd

input = pd.read_excel("451 Consecutive Numbers.xlsx", usecols="A")
test = pd.read_excel("451 Consecutive Numbers.xlsx",  usecols="D:E", nrows = 2)

result = input.assign(group=(input["Numbers"] != input["Numbers"].shift()).cumsum(),
                      pos=input["Numbers"].apply(lambda x: "P" if x > 0 else "N")) \
    .groupby(["group", "Numbers", "pos"]) \
    .size().reset_index(name="count") \
    .groupby("pos") \
    .apply(lambda x: x[x["count"] == x["count"].max()]) \
    .reset_index(drop=True) \
    .groupby("pos") \
    .agg(Number=("Numbers", lambda x: ", ".join(map(str, x.unique()))),
         Count=("count", "first")) \
    .sort_values("Count", ascending=False) \
    .reset_index(drop=True)

print(result)
print(test)
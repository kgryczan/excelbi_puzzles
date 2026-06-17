import pandas as pd

path = "1000-1099/1001/1001 Group Creation.xlsx"
input = pd.read_excel(path, usecols="A", nrows=24, skiprows=1)
test = pd.read_excel(path, usecols="C:D", nrows=3, skiprows=1, dtype=str)

df = input.rename(columns={input.columns[0]: "Data"})
t = df["Data"].astype(str).str.contains(r"\d+").astype(int)
g = t.ne(t.shift()).cumsum().sub(1).floordiv(2)

result = (
    df.assign(group=g, type=t)
    .groupby(["group", "type"])["Data"]
    .agg(lambda s: ", ".join(pd.unique(s.dropna().astype(str))))
    .unstack("type")
    .rename(columns={0: "Groups", 1: "Numbers"})
    .reindex(columns=["Groups", "Numbers"])
    .reset_index(drop=True)
)

print(result.equals(test))
# True

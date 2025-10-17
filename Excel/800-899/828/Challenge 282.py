import pandas as pd

path = "800-899/828/828 Group By.xlsx"

input = pd.read_excel(path, usecols="A", skiprows=1, nrows=20)
test  = pd.read_excel(path, usecols="B:F", skiprows=1, nrows=4)

s = input["Numbers"]
cid = s.ne(s.shift()).cumsum()
auxn = s.groupby(cid).cumcount().add(1)
group = auxn.eq(2).cumsum().add(1)

df2 = input.loc[auxn.eq(1)].assign(group=group[auxn.eq(1)])
df2["rn"] = df2.groupby("group").cumcount().add(1)

wide = (df2.pivot(index="rn", columns="group", values="Numbers")
    .rename(columns=lambda c: f"Group{int(c)}")
    .reset_index(drop=True)
    .astype({f"Group{i+1}": dt for i, dt in enumerate(test.dtypes)}, errors="ignore"))

print(wide.equals(test)) # True 
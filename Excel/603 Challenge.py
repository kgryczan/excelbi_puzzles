import pandas as pd

path = "603 Missing Numbers.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=4, header=None)
test = pd.read_excel(path, usecols="E", nrows=6).astype("str")

V1 = input.values.flatten()
missing_nums = sorted(set(range(min(V1), max(V1) + 1)) - set(V1))

df_missing = pd.DataFrame(missing_nums, columns=["Missing Numbers"])
df_missing['index'] = (df_missing.diff() != 1).cumsum()

df_missing = df_missing.groupby('index')['Missing Numbers'].apply(
    lambda group: str(group.iloc[0]) if len(group) == 1 else f"{group.iloc[0]}-{group.iloc[-1]}"
).reset_index(drop=True)

print(df_missing.equals(test['Answer Expected'])) # True
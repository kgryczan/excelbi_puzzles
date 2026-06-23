import pandas as pd

path = "1000-1099/1005/1005 - Overlapping Words.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=21, skiprows=1)
test = pd.read_excel(path, usecols="D:E", nrows=3, skiprows=1)

result = (
    input.groupby("Group")["Fragment"]
    .agg(lambda x: x.iloc[0] + "".join(s[-1] for s in x.iloc[1:]))
    .reset_index(name="Word")
)

# different words

import pandas as pd

input_data = pd.read_excel("PQ_Challenge_157.xlsx", usecols="A:E", nrows=31)
test = pd.read_excel("PQ_Challenge_157.xlsx", usecols="G:K", nrows=31).astype(str)

result = input_data.astype(str).copy()

def mark_changes(group):
    out = group.copy()
    for col in out.columns:
        out[col] = out[col].where(out[col].shift().ne(out[col]) & out[col].shift().notna())
    return out

result = result.groupby("Group", group_keys=False).apply(mark_changes).reset_index(drop=True)
print(result.equals(test))

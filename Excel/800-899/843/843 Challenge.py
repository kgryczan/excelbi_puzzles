import pandas as pd

path = "Excel/800-899/843/843 Consecutive Index.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=22)
test = pd.read_excel(path, usecols="B", skiprows=1, nrows=22)

col = input.iloc[:, 0]
groups = (col != col.shift().fillna(col.iloc[0])).cumsum()
valid = groups.map(groups.value_counts()) > 1
rank_map = {g: i+1 for i, g in enumerate(sorted(groups[valid].unique()))}
result = groups.where(valid).map(rank_map)

print(result.equals(test.Index)) # True
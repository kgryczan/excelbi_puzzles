import pandas as pd

input_data = pd.read_excel("PQ_Challenge_144.xlsx", usecols="A:B", nrows=16)
test = pd.read_excel("PQ_Challenge_144.xlsx", usecols="E:G", nrows=16)

result = input_data.copy()
group_pos = result.groupby("Group").cumcount() + 1
group_size = result.groupby("Group")["Value"].transform("size")
result["Half"] = ["First" if pos <= (size + 1) // 2 else "Second" for pos, size in zip(group_pos, group_size)]
result["Running Total"] = result.groupby(["Group", "Half"])["Value"].cumsum()
result = result.drop(columns="Half")

print(result.equals(test))

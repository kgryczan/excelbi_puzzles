import pandas as pd
import re

path = "300-399/326/PQ_Challenge_326.xlsx"
input1 = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=7)
input2 = pd.read_excel(path, usecols="A:B", skiprows=10, nrows=11)
test = pd.read_excel(path, usecols="D:I", skiprows=1, nrows=7).rename(columns=lambda c: c.replace('.1', ''))

delims = input2.groupby("ID")["Splitter"].apply(lambda x: "(?i)" + "|".join(map(re.escape, x)))
result = input1.assign(pattern=input1["ID"].map(delims))
result["split_col"] = result.apply(lambda r: [s for s in re.split(r["pattern"], r["Data"]) if s], axis=1)
max_len = result["split_col"].str.len().max()
for i in range(max_len):
    result[f"Data{i+1}"] = result["split_col"].apply(lambda x: x[i] if i < len(x) else None)
final = result[["ID"] + [f"Data{i+1}" for i in range(max_len)]]
print(final.equals(test))

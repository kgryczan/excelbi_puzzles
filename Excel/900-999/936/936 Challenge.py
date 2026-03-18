import pandas as pd
import re

path = "900-999/936/936 Extract Name ID.xlsx"
input_df = pd.read_excel(path, usecols="A", skiprows=1, nrows=10, header=0)
test = pd.read_excel(path, usecols="C:E", skiprows=1, nrows=18, header=0)

pattern = r'([A-Z]+)\s+([A-Z]+)\s+\((\d+)\)'

records = []
for val in input_df["Data"].dropna():
    for m in re.finditer(pattern, val):
        records.append({"Surname": m.group(1), "First Name": m.group(2), "ID": int(m.group(3))})

result = pd.DataFrame(records).reset_index(drop=True)

print(result.equals(test))
# True

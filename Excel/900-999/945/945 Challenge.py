import pandas as pd

path = "900-999/945/945 Extract Data.xlsx"

data = pd.read_excel(path, usecols="A", nrows=25, skiprows=1, header=None, names=["Data"]).query('Data != "---"')
test = pd.read_excel(path, usecols="C:E", nrows=3, skiprows=1)

data[["Name", "Value"]] = data["Data"].str.split(": ", n=1, expand=True)
data["group"] = (data["Name"] == "USER").cumsum()

pivot = data.pivot(index="group", columns="Name", values="Value").reset_index(drop=True)
pivot = pivot.loc[pivot["DATE"] == "2026-03-30"]
pivot["Final Status"] = pivot.apply(lambda r: f"Pending ({r['SIZE']})" if r.get("STATUS") == "Pending" else r.get("STATUS"), axis=1)

result = pivot[["USER", "ACTION", "Final Status"]].rename({"USER": "Username", "ACTION": "Action"}, axis=1).reset_index(drop=True)

print(result.equals(test))
# > True
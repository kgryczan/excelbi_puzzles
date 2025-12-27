import pandas as pd

path = "Power Query/300-399/351/PQ_Challenge_351.xlsx"
input1 = pd.read_excel(path, usecols="A:F", nrows=21)
input2 = pd.read_excel(path, usecols="H:I", nrows=5).rename(columns=lambda col: col.replace('.1', ''))
test = pd.read_excel(path, usecols="H:J", skiprows=11, nrows=5)

result = (
    input1.groupby(["ID", "Name", "Department"], as_index=False)
    .agg({"Sales": "sum", "Annual Target": "first"})
    .merge(input2, on="Department", how="left")
)
result["Annual Bonus"] = (
    ((result["Sales"] - result["Annual Target"]).clip(lower=0) * result["Base Bonus Rate"]).astype('int64')
)
result = result[["ID", "Name", "Annual Bonus"]]

print(result.equals(test)) # True

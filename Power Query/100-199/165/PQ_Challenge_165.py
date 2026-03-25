import pandas as pd

input_data = pd.read_excel("PQ_Challenge_165.xlsx", usecols="A:C", nrows=11)
test = pd.read_excel("PQ_Challenge_165.xlsx", usecols="F:I", nrows=15)

result = input_data.copy()
result["Max Bonus"] = result["Salary"] * 0.1
result["group"] = result["Dept"].notna().cumsum()

parts = []
for _, g in result.groupby("group"):
    summary = pd.DataFrame([{
        "Dept": "Total",
        "Emp": str(len(g)),
        "Salary": g["Salary"].sum(),
        "Max Bonus": g["Max Bonus"].sum(),
        "group": g["group"].iloc[0],
    }])
    parts.append(pd.concat([g, summary], ignore_index=True))

r2 = pd.concat(parts, ignore_index=True)
grand_total = pd.DataFrame([{
    "Dept": "Grand Total",
    "Emp": str(len(r2.dropna(subset=["group"]))),
    "Salary": r2.dropna(subset=["group"])["Salary"].sum(),
    "Max Bonus": r2.dropna(subset=["group"])["Max Bonus"].sum(),
}])
result2 = pd.concat([r2.drop(columns="group"), grand_total], ignore_index=True)

print(result2.equals(test))

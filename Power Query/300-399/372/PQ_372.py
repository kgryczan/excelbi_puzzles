import pandas as pd

path = "300-399/372/PQ_Challenge_372.xlsx"

input = pd.read_excel(path, usecols="A:D", nrows=50)
test = pd.read_excel(path, usecols="G:I", nrows=7).rename(columns=lambda c: c.replace('.1', ''))

total_hours = input.groupby("Employee")["Hours"].sum()
g = input.groupby(["Employee", "Project"])["Hours"].sum()
top = g[g == g.groupby("Employee").transform("max")].reset_index()
top["Top Project"] = top.sort_values("Project").groupby("Employee")["Project"].transform(lambda x: ", ".join(x))
top["Total Hours"] = top["Employee"].map(total_hours)

result = top.groupby("Employee", as_index=False).first()[["Employee", "Top Project", "Total Hours"]]
result = pd.concat([result, pd.DataFrame([{"Employee": "Total", "Top Project": None, "Total Hours": result["Total Hours"].sum()}])], ignore_index=True)
 
result = result.fillna("")
test = test.fillna("")
print(result.equals(test))
# True
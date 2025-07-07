import re
import pandas as pd

path = "700-799/754/754 Table Transformation.xlsx"

input = pd.read_excel(path, skiprows=1, nrows=17, usecols="A:B")
test = pd.read_excel(path, skiprows=1, nrows=4, usecols="D:G")

input[["Data1","Data2"]] = (
    input[["Data1","Data2"]]
    .replace(",", "", regex=True)
    .apply(lambda s: s.astype(str).str.strip())
)
input["grp"], input["pos"] = input.index//4+1, input.index%4+1

rows=[]
for _, g in input.groupby("grp"):
    if len(g)<4: continue
    g=g.set_index("pos")
    rows.append({
        g.at[1,"Data1"]: g.at[2,"Data1"],
        g.at[1,"Data2"]: g.at[2,"Data2"],
        g.at[3,"Data2"]: g.at[4,"Data1"]
    })

result = pd.DataFrame(rows).fillna({"Salary":"","Age":""})
result[["Salary","Age"]] = result[["Salary","Age"]].apply(lambda c: pd.to_numeric(c, errors="coerce"))
result = result.reindex(columns=["Employee","Dept","Salary","Age"], fill_value=None)

print(result.equals(test)) # True
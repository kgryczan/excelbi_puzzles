import pandas as pd

path = "300-399/325/PQ_Challenge_325.xlsx"
input = pd.read_excel(path, usecols="A:H", nrows=4)
test = pd.read_excel(path, usecols="A:B", skiprows=8, nrows=5)

df = input.melt(id_vars=["Employee", "Date"], var_name="name", value_name="value")
df[["Task", "var"]] = df["name"].str.split("_", expand=True)
df = df.pivot(index=["Employee", "Date", "Task"], columns="var", values="value").reset_index()
result = df.groupby("Project", as_index=False).agg(Hours=("Hours", "sum")).rename(columns={"Project": "Projects"})
result["Hours"] = result["Hours"].astype(int)
result = pd.concat([result, pd.DataFrame([{"Projects": "Total", "Hours": result["Hours"].sum()}])], ignore_index=True)

print(result.equals(test)) # True
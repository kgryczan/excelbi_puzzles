import pandas as pd

path = "300-399/390/PQ_Challenge_390.xlsx"
input = pd.read_excel(path, usecols="A", nrows=9)
test = pd.read_excel(path, usecols="C:E", nrows=13)

pattern = r"^\s*(?=[^,]*-\s*([^,]+?)\s*$)([^(,-]+?)\s*(\([^)]+\))?\s*-\s*[^,]+?\s*$"
tmp = (input.rename(columns={input.columns[0]: "Data"}).assign(Data=lambda d: d["Data"].str.split(r",\s*")).explode("Data")["Data"].str.extract(pattern))
tmp.columns = ["State", "City", "Capitality"]
result = (tmp.assign(Capitality=tmp["Capitality"].eq("(C)").map({True: "Capital", False: "Other Cities"}))
			.groupby(["State", "Capitality"], as_index=False)["City"].agg(", ".join)
			.pivot(index="State", columns="Capitality", values="City")
			.reset_index()
			.sort_values("State"))

print(result.equals(test))
# One discrepancy: New Mexico spelled without space in test data.
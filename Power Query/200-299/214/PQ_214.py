import pandas as pd

path = "PQ_Challenge_214.xlsx"
input = pd.read_excel(path, usecols="A:C")
test = pd.read_excel(path, usecols="E:J", nrows=6)

test[test.columns[test.columns.str.contains("Count")]] = test[test.columns[test.columns.str.contains("Count")]].astype("float64")

result = input.sort_values(by=["Animals", "Zoo"]).assign(nr=lambda x: x.groupby("Zoo").cumcount() + 1).pivot(index="nr", columns="Zoo", values=["Animals", "Count"]).reset_index(drop=True)
result.columns = [' '.join(col).strip() for col in result.columns.values]
result = result[["Animals Zoo1", "Count Zoo1", "Animals Zoo2", "Count Zoo2", "Animals Zoo3", "Count Zoo3"]]
result.columns = test.columns
result[result.columns[result.columns.str.contains("Count")]] = result[result.columns[result.columns.str.contains("Count")]].astype("float64")

print(result.equals(test)) # True

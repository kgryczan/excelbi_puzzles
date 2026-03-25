import pandas as pd

input_data = pd.read_excel("PQ_Challenge_159.xlsx", usecols="A:D", nrows=19)
test = pd.read_excel("PQ_Challenge_159.xlsx", usecols="F:I", nrows=73)

calendar = []
for name, g in input_data.groupby("Name"):
    for year in sorted(g["Year"].unique()):
        for month in range(1, 13):
            calendar.append({"Name": name, "Year": year, "Month": month})
calendar = pd.DataFrame(calendar)
result = calendar.merge(input_data, on=["Name", "Year", "Month"], how="left")
result["Sales"] = result["Sales"].fillna(100)

print(result.equals(test))

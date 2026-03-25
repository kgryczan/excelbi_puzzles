import pandas as pd

input_data = pd.read_excel("PQ_Challenge_182.xlsx", usecols="A:D", nrows=20)
test = pd.read_excel("PQ_Challenge_182.xlsx", usecols="F:I", nrows=11, header=None)
test.iloc[:, 0] = test.iloc[:, 0].astype(str).str.replace("5/1/2014", "2014-05-01", regex=False)

result = input_data.pivot(index="Date", columns="Data", values="Value").reset_index()
result["rn"] = range(1, len(result) + 1)
r1 = result.groupby("Date", as_index=False).first()[["Date"]].copy()
r1["Data1"] = "Data1"
r1["Data2"] = "Data2"
r1["Data3"] = "Data3"
r1["rn"] = 0
r2 = pd.concat([result, r1], ignore_index=True).sort_values(["Date", "rn"]).drop(columns=["Date", "rn"])
r2.columns = test.columns

print(r2.equals(test))

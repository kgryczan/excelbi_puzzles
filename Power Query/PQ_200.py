import pandas as pd

path = "PQ_Challenge_200.xlsx"
input1 = pd.read_excel(path, usecols="A:D", nrows = 5)
input2 = pd.read_excel(path, usecols="F:I", nrows=5)
input2.columns = input2.columns.str.replace(".1", "")
test = pd.read_excel(path, usecols="A:E", skiprows = 10, nrows = 6)

in1 = input1.melt(id_vars=["Student"], var_name="subject", value_name="score")
in2 = input2.melt(id_vars=["Student"], var_name="subject", value_name="score")

result = pd.concat([in1, in2]).groupby(["subject", "Student"]).agg(max_score=("score", "max")).reset_index()
result = result.pivot(index="Student", columns="subject", values="max_score").reset_index()
result = result.sort_values("Student")
result.columns.name = None

result.iloc[:, 1:] = result.iloc[:, 1:].fillna(0).astype("float64")
test.iloc[:, 1:] = test.iloc[:, 1:].fillna(0).astype("float64")

print(result.equals(test)) # True
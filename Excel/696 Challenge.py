import pandas as pd

path = "696 Pass or Fail.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=17)
test = pd.read_excel(path, usecols="E:F", skiprows=1, nrows=5, names=["Student", "Result"]).sort_values("Student").reset_index(drop=True)

result = pd.pivot_table(input, index="Student", columns="Subject", values="Pass", fill_value="Y", aggfunc='first')
result = result.reset_index()
result = result.assign(Result=lambda df: ["Pass" if ((row["Maths"] == "Y" or row["Science"] == "Y") and row["English"] == "Y" and row["Philosophy"] == "Y") else "Fail" for _, row in df.iterrows()])
result = result[["Student", "Result"]].sort_values("Student").reset_index(drop=True)
result.index.name = None

print(result.equals(test)) # True
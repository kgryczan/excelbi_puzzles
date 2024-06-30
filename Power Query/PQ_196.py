import pandas as pd

path = "PQ_Challenge_196.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=11)
test = pd.read_excel(path, usecols="F:O", nrows=4)

result = input.copy()
result["class1"] = result["Class"]
result = result.pivot_table(index=["class1"], columns=["Subject"], values=["class1", "Marks"], aggfunc="first", fill_value="")
result.columns = result.columns.map(lambda x: "-".join(x))
result = result.reset_index()
result = result.sort_index(axis=1)
result.columns = result.columns.str.replace("Class-", "")
result = result.drop(columns=["class1"])
result = result.applymap(lambda x: pd.to_numeric(x, errors="coerce", downcast="integer"))
test = test.applymap(lambda x: pd.to_numeric(x, errors="coerce", downcast="integer"))

print(result.equals(test)) # True
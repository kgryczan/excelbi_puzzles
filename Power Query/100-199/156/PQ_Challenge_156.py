import pandas as pd

input1 = pd.read_excel("PQ_Challenge_156.xlsx", usecols="A:B", nrows=10)
input2 = pd.read_excel("PQ_Challenge_156.xlsx", usecols="D:E", nrows=5)
test = pd.read_excel("PQ_Challenge_156.xlsx", usecols="G:K", nrows=6)

result = input1.merge(input2, on="Subjects", how="left")
result = result.pivot(index="Name", columns="Subjects", values="Teacher").reset_index()
result = result[["Name", "Biology", "Chemistry", "Geology", "Physics"]]

print(result.equals(test))

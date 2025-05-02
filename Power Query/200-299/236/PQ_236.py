import pandas as pd

path = "PQ_Challenge_236.xlsx"

input = pd.read_excel(path, usecols="A:F", nrows=4)
test = pd.read_excel(path, usecols="I:J", nrows=16)

result = input.T.values.tolist()
result = list(zip(*result))
result = [item for sublist in result for item in sublist]

result = pd.DataFrame(result, columns=["Data2"])
result["Data1"] = input.columns.tolist() * 4
result = result[["Data1", "Data2"]]
result = result.dropna()

result["Count"] = result.groupby("Data2").cumcount() + 1
result = result[~((result["Count"] == 2) & (result["Data1"] == "Hall"))]
result = result.drop(columns="Count").reset_index(drop=True)

print(result.equals(test))    # True    

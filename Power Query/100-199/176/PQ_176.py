import pandas as pd

input = pd.read_excel("PQ_Challenge_176.xlsx", sheet_name="Sheet1", usecols="A:C", nrows=4)
test = pd.read_excel("PQ_Challenge_176.xlsx", sheet_name="Sheet1",  usecols="E:G", nrows=9)
test.columns = input.columns

input["Column1"] = input["Column1"].str.split(", ")
input["Column2"] = input["Column2"].str.split(", ")

result = []
for i in range(len(input)):
    column1 = input["Column1"][i]
    column2 = input["Column2"][i]
    if len(column1) > len(column2):
        column2 += ["0"]*(len(column1)-len(column2))
    elif len(column2) > len(column1):
        column1 += [None]*(len(column2)-len(column1))
    result.append(list(zip(column1, column2)))
result = pd.DataFrame([item for sublist in result for item in sublist], columns=["Column1", "Column2"])
result = result.dropna()

groups = input[["Group", "Column1"]].explode("Column1").dropna()
merged = pd.merge(result, groups, on="Column1", how="left")
merged = merged[["Group", "Column1", "Column2"]].reset_index(drop=True)
merged["Column2"] = pd.to_numeric(merged["Column2"])
merged["Column2"] = merged.groupby("Group")["Column2"].cumsum()

print(merged.equals(test)) # True
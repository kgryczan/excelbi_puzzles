import pandas as pd

path = "1000-1099\1046\1046 Single Product Name.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1)
test = pd.read_excel(path, usecols="E:F", skiprows=1, nrows=7)
test.columns = ["Company", "Product"]

words = input.assign(Word=input.Description.str.split()).explode("Word")
words["Position"] = words.groupby("RecordID").cumcount() + 1
words["Company"] = pd.Categorical(words.Company, input.Company.unique(), ordered=True)
result = (
    words.groupby(["Company", "Word"], as_index=False, observed=True)
    .Position.mean()
    .sort_values(["Company", "Position", "Word"])
    .groupby("Company", sort=False, observed=True)
    .Word.agg(" ".join)
    .reset_index(name="Product")
)
result["Company"] = result.Company.astype(str)
print(result.equals(test))

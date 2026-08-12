import pandas as pd

path = "1000-1099/1041/1041 Grouping.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=21)
test = pd.read_excel(path, usecols="C:D", skiprows=1, nrows=3)


data = input["Data"].str.split(" : ", expand=True)
data.columns = ["Category", "Code", "Type", "Amount"]

data["Category"] = data["Category"].str.split(">").str[0]

result = (
    data.assign(
        Amount=pd.to_numeric(data["Amount"])
        * data["Type"].map({"Return": -1, "Promotion": 0}).fillna(1)
    )
    .groupby("Category", as_index=False)["Amount"]
    .sum()
    .sort_values("Category")
    .astype({"Amount": "int64"})
)

print(result.equals(test))

import pandas as pd

path = "700-799/757/757 Alignment of Zoo Animals & Birds.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=13)
test = pd.read_excel(path, usecols="C:E", skiprows=1, nrows=4)

input["zoo"] = input["Data"].where(input["Data"].str.startswith("Zoo"), pd.NA)
input["category"] = input["Data"].where(input["Data"].isin(["Animal", "Bird"]), pd.NA)
input[["zoo", "category"]] = input[["zoo", "category"]].ffill()

filtered = input[
    (~input["Data"].isin(["Animal", "Bird"])) &
    (input["Data"] != input["zoo"])
]

filtered = filtered[["zoo", "category", "Data"]].rename(columns={"Data": "item"})
filtered["r"] = filtered.groupby(["zoo", "category"]).cumcount() + 1

result = filtered.pivot(index=["zoo", "r"], columns="category", values="item").reset_index()
result = result.drop(columns="r").rename(columns={"zoo": "Zoo"})
result = result[["Zoo", "Animal", "Bird"]]

print(result.equals(test))

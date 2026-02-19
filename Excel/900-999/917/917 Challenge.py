import pandas as pd

path = "Excel/900-999/917/917 Extract and Vstack.xlsx"
input = pd.read_excel(path, usecols="A:E", skiprows=1, nrows=20)
test = pd.read_excel(path, usecols="G:K", skiprows=1, nrows=4).rename(columns=lambda x: x.rstrip('.1'))

result = (
    input
    .groupby("Case No", group_keys=False, dropna=False)
    .apply(lambda g: g.ffill().bfill())
    .groupby("Case No", as_index=False)
    .agg({
        "Company": "first",
        "Start Date": "min",
        "Finish Date": "max",
        "Contact": "last"
    })
)

print(result.equals(test))
# Output: True
import pandas as pd

path = "1000-1099/1018/1018 Extract Employees.xlsx"
input = pd.read_excel(path, usecols="A", nrows=4, skiprows=1)
test = pd.read_excel(path, usecols="C:E", nrows=8, skiprows=1)

result = (
    input.assign(
        Department=lambda x: x["Data"].str.split(": ", n=1).str[0],
        Employee=lambda x: x["Data"].str.split(": ", n=1).str[1].str.split(r" \| "),
    )
    .explode("Employee")
    .assign(
        Employee_Name=lambda x: x["Employee"].str.extract(r"^(.+?)\s*\[ID:(\d+)\]")[0],
        Employee_ID=lambda x: x["Employee"]
        .str.extract(r"^(.+?)\s*\[ID:(\d+)\]")[1]
        .astype(int),
    )
    .drop(columns=["Data", "Employee"])
    .reset_index(drop=True)
)

print(result.equals(test))
# True

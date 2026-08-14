import pandas as pd

path = "1000-1099/1043/1043 Extraction.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=11)
test = pd.read_excel(path, usecols="C:F", skiprows=1, nrows=11)

result = (
    input.assign(rn=lambda x: range(len(x)))
    .assign(Data=lambda x: x["Data"].str.split(" "))
    .explode("Data")
    .assign(
        valid=lambda x: x["Data"].str.match(r"^\(.*\)$|^\[.*\]$|^\{.*\}$"),
        Data=lambda x: x["Data"].str.replace(r"[\[\]{}()]", "", regex=True),
    )
)
result[["name", "value"]] = result["Data"].str.split(":", n=1, expand=True)
result["value"] = result["value"].where(result["valid"])
result = (
    result.pivot_table(
        index="rn",
        columns="name",
        values="value",
        aggfunc=lambda x: None if x.dropna().empty else ", ".join(x.dropna()),
    )
    .reindex(range(len(input)))
    .reset_index(drop=True)
    .sort_index(axis=1)
)

print(result.equals(test))
# True

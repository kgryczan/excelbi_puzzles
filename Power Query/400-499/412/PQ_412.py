import pandas as pd

path = "400-499/412/PQ_Challenge_412.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=20)
test = pd.read_excel(path, usecols="E:K", nrows=5)
test.columns = ["Technician", "Electrical", "Mechanical", "Plumbing", "HVAC", "Safety", "Total"]
categories = ["Electrical", "Mechanical", "Plumbing", "HVAC", "Safety"]

details = (
    input.assign(Detail=input["Detail"].str.split("|"))
    .explode("Detail")
    .assign(
        Category=lambda df: df["Detail"].str.split(":").str[0],
        Value=lambda df: pd.to_numeric(df["Detail"].str.split(":").str[1]),
    )
)

result = (
    details.pivot_table(
        index="Technician", columns="Category", values="Value", aggfunc="sum", fill_value=0
    )
    .reindex(columns=categories, fill_value=0)
    .reset_index()
)
result["Total"] = result[categories].sum(axis=1)
result = pd.concat(
    [result, pd.DataFrame([["Total", *result[categories].sum(), result["Total"].sum()]],
                          columns=result.columns)],
    ignore_index=True,
)

print(result.equals(test))
# True

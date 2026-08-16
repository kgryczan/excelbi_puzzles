import pandas as pd

path = r"C:\Users\kgryc\Documents\excelbi_puzzles\Power Query\400-499\418\PQ_Challenge_418.xlsx"
input = pd.read_excel(path, usecols="A:B")
test = pd.read_excel(path, usecols="D:G", nrows=5)

data = input.assign(
    form=input.Value1.eq("FORM").cumsum(),
    Region=input.Value2.where(input.Value1.eq("FORM")).ffill(),
)
data["value"] = data.groupby("form").Value2.shift(-1)
fields = data[data.Value1.eq("FIELD")]

result = pd.DataFrame(
    [
        {
            "Customer": g.loc[g.Value2.eq("Customer"), "value"].iat[0],
            "Region": g.Region.iat[0],
            "Product": ", ".join(g.loc[g.Value2.eq("Product"), "value"]),
            "Amount": pd.to_numeric(g.loc[g.Value2.eq("Amount"), "value"]).sum(),
        }
        for _, g in fields.groupby("form", sort=False)
    ]
)

test.Product = test.Product.str.replace(r"\s+", " ", regex=True).str.strip()
test.Amount = test.Amount.astype(int)
print(result.equals(test))

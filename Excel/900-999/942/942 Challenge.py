import pandas as pd

path = "900-999/942/942 Matrix.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=21, skiprows=1)
test = pd.read_excel(path, usecols="D:J", nrows=6, skiprows=1)

res = input.drop_duplicates()

result = (
    input.merge(res, on="Order_ID")
       .value_counts(["Product_x", "Product_y"])
       .unstack(fill_value=0)
       .sort_index()
       .pipe(lambda x: x.reindex(sorted(x.columns), axis=1))
).reset_index()

test = test.rename(columns={"Product.1": "Product"})
result = result.rename(columns={"Product_x": "Product"})

print((result == test).all().all())
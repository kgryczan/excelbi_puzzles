import pandas as pd

path = "Power Query/300-399/357/PQ_Challenge_357.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows = 50)
test  = pd.read_excel(path, usecols="F:L", nrows = 10).rename(columns=lambda col: col.replace('.1', ''))

result = (
    input
      .assign(
          Categories=lambda d: d["Categories"].fillna("").astype(str).str.split(";"),
          no_cat=lambda d: d["Categories"].str.len(),
          Region=lambda d: d["Region"].fillna("Unknown"),
          Year=lambda d: pd.to_datetime(d["OrderDate"]).dt.year
      )
      .assign(cat_amount=lambda d: d["Amount"] / d["no_cat"])
      .explode("Categories")
      .groupby(["Region", "Year", "Categories"], as_index=False)
      .agg(cat_amount=("cat_amount", "sum"))
      .pivot(
          index=["Region", "Year"],
          columns="Categories",
          values="cat_amount"
      )
      .fillna(0)
      .reset_index()
      .sort_values(["Region", "Year"])
)

num_cols = result.columns.difference(["Region", "Year"])
result[num_cols] = result[num_cols].round(2)

print(result.equals(test))
# Discrepancies based on rounding.
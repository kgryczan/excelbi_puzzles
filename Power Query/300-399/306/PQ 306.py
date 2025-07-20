import pandas as pd

path = "300-399/306/PQ_Challenge_306.xlsx"
input = pd.read_excel(path, usecols="A:E", nrows=7)
test = pd.read_excel(path, usecols="G:N", nrows=4).sort_values(by="Customer").reset_index(drop=True)

result = (input.melt(id_vars=input.columns[0], var_name="Customer", value_name="v")
    .assign(Amt=lambda df: df.groupby("Customer")["v"].transform(lambda x: x[x > 0].min()),
            EMI=lambda df: df["v"] / df["Amt"])
    .pivot_table(index=["Customer", "Amt"], columns=input.columns[0], values="EMI", aggfunc="first")
    .reset_index().reindex(columns=["Customer", "Amt"] + list(input[input.columns[0]].unique())))
result.columns.name = None
result = result.map(lambda x: int(x) if pd.notnull(x) and isinstance(x, (int, float)) else x)

print(result.equals(test)) # True
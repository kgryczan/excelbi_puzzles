import pandas as pd

path = "200-299/284/PQ_Challenge_284.xlsx"

input = pd.read_excel(path, usecols="A:D", nrows=20)
test = pd.read_excel(path, usecols="F:J", nrows=6)

result = (input.melt(var_name="name", value_name="value")
          .assign(bin=lambda df: pd.cut(df['value'], bins=range(0, 101, 20), include_lowest=True))
          .pivot_table(index="bin", columns="name", values="value", aggfunc="sum")
          .reset_index()
          .sort_values(by="bin")
          .reset_index(drop=True)
          .pipe(lambda df: df[['bin'] + sorted(df.columns.difference(['bin']), reverse=True)]))


print(result)

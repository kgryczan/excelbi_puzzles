import pandas as pd

path = "PQ_Challenge_241.xlsx"
input = pd.read_excel(path,  usecols="A:F", nrows=5)
test = pd.read_excel(path, usecols="A:F", skiprows=8, nrows=12)

result = (input.melt(id_vars=["Group"], var_name="Name", value_name="Value")
          .assign(Value=lambda df: df["Value"].str.split(", "))
          .explode("Value")
          .assign(rn=lambda df: df.groupby(["Group", "Name"]).cumcount() + 1)
          .pivot(index=["Group", "rn"], columns="Name", values="Value")
          .reset_index()
          .drop(columns="rn"))

result = result.rename_axis(None, axis=1)
result = result.rename(columns={"Group": "Date"})

print(result.equals(test))
# True
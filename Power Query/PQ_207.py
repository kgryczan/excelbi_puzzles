import pandas as pd

path = "PQ_Challenge_207.xlsx"
input = pd.read_excel(path, usecols="A:H", skiprows=1)
test = pd.read_excel(path,  usecols="K:P", skiprows=1, nrows = 7)

r2 = (
    input.melt(id_vars=["Name"], var_name="Day of Week", value_name="Value")
    .query('Value == "Y"')
    .groupby("Day of Week", observed=False)
    .apply(lambda x: x.assign(nr=x.groupby("Day of Week", observed=False).cumcount() + 1))
    .drop("Value", axis=1)
    .pivot(index="Day of Week", columns="nr", values="Name")
    .add_prefix("Name")
    .reindex(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"])
    .reset_index()
    .astype({"Day of Week": str})
    .rename_axis(None, axis=1)
)
print(r2.equals(test)) # True
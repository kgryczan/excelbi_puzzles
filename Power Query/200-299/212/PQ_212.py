import pandas as pd

path = "PQ_Challenge_212.xlsx"
T1 = pd.read_excel(path, skiprows = 1, nrows = 5, usecols="A:C")
T2 = pd.read_excel(path, skiprows = 10, nrows = 6, usecols="A:E")
test = pd.read_excel(path, skiprows = 1, nrows = 5, usecols="H:I")
test.columns = test.columns.str.replace(".1", "")

result = T2.copy()
result = pd.melt(result, id_vars=["Deal", "Sales"], value_vars=["Code1", "Code2", "Code3"], var_name="Code", value_name="Value")\
            .dropna()\
            .merge(T1, left_on="Value", right_on="Code", how="left")\
            .assign(Amount = lambda x: x["Sales"] * x["Commission"])\
            .groupby("Name")["Amount"].sum()\
            .sort_values(ascending=False)\
            .reset_index(drop=False)

print(result.equals(test)) # True
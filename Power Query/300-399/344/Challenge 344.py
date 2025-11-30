import pandas as pd
import numpy as np

input = pd.read_excel("Power Query/300-399/344/PQ_Challenge_344.xlsx", usecols="A", nrows=17, header=None, names=["Value"]).dropna()
test = pd.read_excel("Power Query/300-399/344/PQ_Challenge_344.xlsx", usecols="C:I", nrows=15)

input["Location"] = np.where(input["Value"].str.contains("Location"), input["Value"].str.replace("Location: ", "", regex=False), np.nan)
input["Location"] = input["Location"].ffill()
input = input[~input["Value"].str.contains("Location")]

split_cols = input["Value"].str.split(",", expand=True).rename(columns={0:"Category",1:"SKU",2:"Jan_Stock",3:"Jan_Received",4:"Feb_Stock",5:"Feb_Received",6:"Mar_Stock",7:"Mar_Received"})
input = pd.concat([input[["Location"]], split_cols], axis=1)
input = input[input["Category"] != "Category"]

long = input.melt(id_vars=["Location","Category","SKU"], value_vars=["Jan_Stock","Jan_Received","Feb_Stock","Feb_Received","Mar_Stock","Mar_Received"], var_name="Month_Type", value_name="Value")
long[["Month","Type"]] = long["Month_Type"].str.split("_", expand=True)
result = long.pivot_table(index=["Location","Category","SKU","Month"], columns="Type", values="Value", aggfunc="first").reset_index()
result = result[result["Stock"].notna() & (result["Stock"] != "")]
result[["Starting Stock","Received Stock"]] = result[["Stock","Received"]].astype(int)
result = result.drop(columns=["Stock","Received"])

result = result.reset_index(drop=True)
test = test.reset_index(drop=True)
location_order = ["North", "South", "East"]
month_order = ["Jan", "Feb", "Mar"]

result["Location"] = pd.Categorical(result["Location"], categories=location_order, ordered=True)
result["Month"] = pd.Categorical(result["Month"], categories=month_order, ordered=True)

result = result.sort_values(
    by=["Location", "Category", "SKU", "Month"],
    ascending=[True, True, True, True]
).reset_index(drop=True)

result['Location'] = result['Location'].astype(str)
result['Category'] = result['Category'].astype(str)
result['Month'] = result['Month'].astype(str)


result["Sold"] = (
    result["Starting Stock"] + result["Received Stock"] -
    result.groupby(["Location","Category"])["Starting Stock"].shift(-1)
)

print(test.equals(result)) # True
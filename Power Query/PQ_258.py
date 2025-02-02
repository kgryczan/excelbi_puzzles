import pandas as pd
import numpy as np

path = "PQ_Challenge_258.xlsx"
months = pd.Categorical(['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                         'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'], 
                        categories=['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'], 
                        ordered=True)

input = pd.read_excel(path, skiprows=1, nrows=6, usecols="A:D")
test = pd.read_excel(path, skiprows=10, nrows=6, usecols="A:M").fillna(0).sort_values(by = 'Name').reset_index(drop = True)

input["year"] = 2025
df_expanded = input.loc[np.repeat(input.index, input["Total Months"])].copy()
df_expanded["month_amount"] = df_expanded["Amout"] / df_expanded["Total Months"]
df_expanded["month_num"] = df_expanded["Start Month"].apply(lambda x: months.categories.get_loc(x) + 1) + df_expanded.groupby("Name").cumcount()

overflow = df_expanded["month_num"] > 12
df_expanded.loc[overflow, "year"] += 1
df_expanded.loc[overflow, "month_num"] = df_expanded.loc[overflow, "month_num"] - 12

df_expanded["month"] = df_expanded["month_num"].apply(lambda x: months[x - 1])
r2 = df_expanded[["Name", "year", "month", "month_amount"]]

r3 = pd.DataFrame([(2025, m, n) for n in input["Name"].unique() for m in months], 
                  columns=["year", "month", "Name"]).merge(r2, on=["year", "month", "Name"], how="left")

r3_pivot = r3.pivot_table(index="Name", columns="month", values="month_amount", 
                          aggfunc='first', fill_value=0).reset_index()

r3_pivot = r3_pivot.reindex(columns=["Name"] + list(months), fill_value=0)
r3_pivot.columns.name = None


print(all(r3_pivot == test)) # True
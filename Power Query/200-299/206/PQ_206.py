import pandas as pd
import numpy as np

path = "PQ_Challenge_206.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows = 12)
test = pd.read_excel(path, usecols="F:K", nrows=18).astype(str).replace("nan", np.NaN)

r1 = input.copy()
r1["group"] = r1["Group1"].isna().cumsum() + 1
r1 = r1[~r1["Group1"].isna()]
r1["nr"] = r1.groupby("group").cumcount() + 1
r1["Group"] = r1["Group1"].astype(str) + "-" + r1["Group2"].astype(str)
r1["Value"] = r1["Value1"].astype(str) + "-" + r1["Value2"].astype(str)
r1 = r1.drop(columns=["Group1", "Group2", "Value1", "Value2"])\
    .melt(id_vars=["nr", "group"], value_vars=["Group", "Value"], var_name="Variable", value_name="MeltedValue")\
    .sort_values(by=["group", "nr"]).reset_index(drop=True).drop(columns=["Variable"])

def rearrange_df(df, part):
    df_part = df[df["group"] == part].drop(columns=["group"]).reset_index(drop=True)
    df_part["col"] = df_part["nr"]
    df_part["row"] = df_part.index + 1
    df_part = df_part.pivot(index="row", columns="col", values="MeltedValue").rename(columns=lambda x: "c" + str(x))
    df_part = df_part.map(lambda x: x.split("-", maxsplit=1) if isinstance(x, str) else x)
    return df_part

r2 = pd.concat([rearrange_df(r1, i) for i in r1["group"].unique()], axis=0).reset_index(drop=True)
r2 = pd.concat([r2[col].apply(pd.Series) for col in r2.columns], axis=1)
r2.columns = test.columns
r2 = r2.replace({"nan": np.NaN, "\\.0": ""}, regex=True)

print(r2.equals(test)) # True
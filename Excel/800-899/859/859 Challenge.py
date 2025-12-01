import pandas as pd
import numpy as np

excel_path = "Excel/800-899/859/859 Extract Numbers and Align.xlsx"
input_df = pd.read_excel(excel_path, usecols="A:B", nrows=6)
test_df = pd.read_excel(excel_path, usecols="C", nrows=12)

input_long = (
    input_df.assign(Data2=input_df["Data2"].str.split(", "))
    .explode("Data2")
    .dropna()
)
input_long["rn"] = input_long.groupby("Data1").cumcount() + 1
input_long = input_long.sort_values(["rn", "Data1"]).reset_index(drop=True)
input_long["Answer Expected"] = input_long["Data1"].astype(str) + input_long["Data2"].astype(str)

print(input_long[['Answer Expected']].equals(test_df)) # True

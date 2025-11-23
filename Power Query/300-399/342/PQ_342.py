import pandas as pd
import numpy as np
from openpyxl import load_workbook

path = "Power Query/300-399/342/PQ_Challenge_342.xlsx"
input_df = pd.read_excel(path, usecols="A:F", nrows=18)
test_df  = pd.read_excel(path, usecols="H:K", nrows=12)

def roll_left(x):
    return x[1:] + [x[0]]

def left_shift(r):
    while r[0] == "" or pd.isna(r[0]):
        r = roll_left(r)
    return r

df = pd.DataFrame([left_shift(row.tolist()) for _, row in input_df.iterrows()], columns=input_df.columns)
df = df.dropna(axis=1, how='all').loc[:, (df != "").any(axis=0)]

res = pd.concat([
    df.iloc[::2][["Col1", "Col2"]].rename(columns={"Col1": "Group1", "Col2": "Group2"}).reset_index(drop=True),
    df.iloc[1::2][["Col1", "Col2"]].rename(columns={"Col1": "Value1", "Col2": "Value2"}).apply(pd.to_numeric, errors='coerce').reset_index(drop=True)
], axis=1)

for idx in [3, 6, 10]:
    res = pd.concat([res.iloc[:idx], pd.DataFrame([[np.nan]*4], columns=res.columns), res.iloc[idx:]], ignore_index=True)

print(res.equals(test_df))  # True
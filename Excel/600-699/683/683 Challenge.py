import pandas as pd
import numpy as np

path = "683 Find Numbers in a Grid.xlsx"
input1 = pd.read_excel(path,  usecols="C:L", skiprows=2, nrows=10, header=None).values
input2 = pd.read_excel(path, usecols="N", skiprows=1, nrows=11)
test = pd.read_excel(path, usecols="O", skiprows=1, nrows=11).assign(Value=lambda df: pd.to_numeric(df.iloc[:, 0]))

result = input2.assign(
    num=lambda df: df.iloc[:, 0].astype(str),
    n=lambda df: df['num'].str.len(),
    mod=lambda df: df['n'] % 2,
    row=lambda df: np.where(df['mod'] == 0, df['num'].str[-2:-1], df['num'].str[-1:]).astype(int) + 1,
    col=lambda df: np.where(df['mod'] == 0, df['num'].str[-1:], df['num'].str[-2:-1]).astype(int) + 1
).assign(
    Value=lambda df: [input1[row-1, col-1] for row, col in zip(df['row'], df['col'])]
).loc[:, ['Value']]

print(result.equals(test))
import pandas as pd
import numpy as np
import re

path = "700-799/746/746 Alignment of Data.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=15)
test = pd.read_excel(path, usecols="D:I", skiprows=1, nrows=7).rename(columns=lambda c: re.sub(r'\.1$', '', c))
i2 = pd.concat([input.iloc[:,0], input.iloc[:,1]]).dropna().astype(str)
digs = i2.str.extract(r'(\d+)').astype(float)[0]
all_digs = pd.Series(np.arange(int(digs.min()), int(digs.max())+1), name='dig')
grouped = pd.DataFrame({'dig': digs.values, 'x': i2.values}).groupby('dig')['x'].apply(lambda xs: ', '.join(xs)).reindex(all_digs).reset_index()
split_cols = grouped['x'].str.split(', ', expand=True)
split_cols.columns = [f'Col{i+1}' for i in range(split_cols.shape[1])]
result = split_cols

print(result.equals(test))
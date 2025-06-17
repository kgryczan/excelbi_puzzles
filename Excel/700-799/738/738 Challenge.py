import pandas as pd
import numpy as np

path = "700-799/738/738 Reorder Columns.xlsx"

xl = pd.read_excel
df = xl(path, sheet_name=0, nrows=10, usecols="A:E")
seq = df["Sequence"].str.split(",\s*", expand=True).replace("", np.nan).astype(float)

cols = df.columns[:-1]
missing = 10 - seq.sum(axis=1)
seq_filled = seq.T.fillna(missing).T.astype(int)
vals = df[cols].to_numpy()
out = [vals[i, row.astype(int) - 1] for i, row in enumerate(seq_filled.values)]

result = pd.DataFrame(out, columns=cols)
print(result)
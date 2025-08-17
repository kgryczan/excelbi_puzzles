import pandas as pd
import numpy as np

path = "300-399/314/PQ_Challenge_314.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=12)
test = pd.read_excel(path, usecols="F:G", nrows=12).rename(columns=lambda col: col.replace('.1', ''))

input['Previous Step'].replace("", np.nan, inplace=True)
def chain(row, prev):
    s, out = row['Step'], [row['Step']]
    while pd.notna(prev.get(s)) and prev[s] not in out:
        s = prev[s]
        out.append(s)
    return "-".join(out)
def build_chain(g):
    prev = dict(zip(g['Step'], g['Previous Step']))
    return g.assign(**{'Steps Chain': g.apply(lambda r: r['Step'] if pd.isna(r['Previous Step']) else chain(r, prev), axis=1)})
result = input.groupby('Process', group_keys=False).apply(build_chain)[['Process', 'Steps Chain']].reset_index(drop=True)

print(result.equals(test))
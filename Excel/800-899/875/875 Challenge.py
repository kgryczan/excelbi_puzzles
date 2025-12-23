
import pandas as pd
import numpy as np

path = "Excel/800-899/875/Excel_Challenge_875 - Counting As Per Criteria.xlsx"
input = pd.read_excel(path, usecols="A", nrows=25)
test = pd.read_excel(path, usecols="B", nrows=25).fillna(0.0)

results = []
for data in input['Data']:
    chars = [c for c in str(data) if c != ' ']
    groups = ''.join(str(data)).split(' ')
    prev = {}
    vars_ = []
    for idx, grp in enumerate(groups, 1):
        for i, c in enumerate(grp):
            if i == 0:
                vars_.append(np.nan)
            else:
                vars_.append(1 if c > grp[i-1] else 0)
    group_sizes = [len(g) for g in groups]
    idx = 0
    group_sums = []
    for sz in group_sizes:
        vals = vars_[idx:idx+sz]
        s = np.nansum(vals)
        if s != 0 and not np.isnan(s):
            group_sums.append(int(s))
        idx += sz
    answer = float(''.join(map(str, group_sums))) if group_sums else 0.0
    results.append(answer)

input['Answer Expected'] = results
print(results == test['Answer Expected'].tolist())

import pandas as pd
import numpy as np

path = "800-899/823/823 VSTACK.xlsx"

input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=5)
test = pd.read_excel(path, usecols="D:E", skiprows=1, nrows=11).rename(columns=lambda x: x.replace('.1', ''))

def split_and_pad(row):
    names = [n.strip() for n in str(row['Names']).split(',')]
    points = [p.strip() for p in str(row['Points']).split(',')]
    l = max(len(names), len(points))
    return pd.DataFrame({'Names': names + [np.nan]*(l-len(names)), 'Points': points + ['0']*(l-len(points))})

result = pd.concat([split_and_pad(r) for _, r in input.iterrows()], ignore_index=True)
result['Points'] = pd.to_numeric(result['Points'], errors='coerce').fillna(0).astype(int)

print(result.equals(test)) # True
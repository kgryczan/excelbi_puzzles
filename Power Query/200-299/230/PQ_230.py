import pandas as pd
import numpy as np

path = "PQ_Challenge_230.xlsx"
input = pd.read_excel(path, usecols="A:H", nrows=17).rename(columns=lambda x: x.split('.')[0])
test = pd.read_excel(path, usecols="J:K", nrows=12).rename(columns=lambda x: x.split('.')[0])

splits = [input.iloc[:, i:i+2] for i in range(0, input.shape[1], 2)]

df = pd.concat(splits, axis=0, ignore_index=True)

df['Week'] = df['Month']
df['Month'] = df.apply(lambda row: row['Week'] if pd.isna(row['Sale']) else np.NaN, axis=1)
df['Month'] = df['Month'].ffill()
summary = df.groupby('Month', as_index=False)['Sale'].sum()

check = test.merge(summary, on='Month', how='left')
check['Check'] = check['Sale_x'] == check['Sale_y']
print(all(check['Check'])) # True
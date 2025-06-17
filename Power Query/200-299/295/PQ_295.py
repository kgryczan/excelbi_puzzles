import pandas as pd
import numpy as np
import re

path = "200-299/295/PQ_Challenge_295.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=18)
test = pd.read_excel(path, usecols="D:G", nrows=11)
test.columns = [col.replace('.1', '') for col in test.columns]

df = input.copy()
df['Serial'] = df['Serial'].astype(str)
df['level'] = df['Serial'].str.count(r'\.')
for i in range(3):
    df[f'Name{i+1}'] = np.where(df['level'] == i, df['Names'], pd.NA)

df['first_digit'] = df['Serial'].str[0]

df[['Name1', 'Name2']] = df.groupby('first_digit')[['Name1', 'Name2']].ffill()
df[['Name2', 'Name3']] = df.groupby('first_digit')[['Name2', 'Name3']].bfill()

result = df[['first_digit', 'Name1', 'Name2', 'Name3']].copy()
result = result.rename(columns={'first_digit': 'Serial'})
result['Serial'] = result['Serial'].astype(int)
result = result.drop_duplicates().reset_index(drop=True)

print(result.equals(test))
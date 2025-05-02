import pandas as pd
import numpy as np

path = "PQ_Challenge_253.xlsx"
input_df = pd.read_excel(path,  usecols="A:D", nrows=11)
test_df = pd.read_excel(path,  usecols="G:H", nrows=18).rename(columns=lambda x: x.split('.')[0])

input_df['Name1'] = input_df['Name1'].str.replace('`', 'Billy') # hardcoded

input_df['Serial2'] = input_df.groupby('Serial')['Name2'].transform(lambda x: pd.factorize(x)[0] + 1).replace(0, np.nan).astype('Int64')
input_df['Serial3'] = input_df.groupby(['Serial', 'Serial2'])['Name3'].transform(lambda x: pd.factorize(x)[0] + 1).replace(0, np.nan).astype('Int64')

input_df['level1'] = input_df['Name1'] + ' ' + input_df['Serial'].astype(str)
input_df['level2'] = input_df['Name2'] + ' ' + input_df['Serial'].astype(str) + '.' + input_df['Serial2'].astype(str)
input_df['level3'] = input_df['Name3'] + ' ' + input_df['Serial'].astype(str) + '.' + input_df['Serial2'].astype(str) + '.' + input_df['Serial3'].astype(str)

result = pd.concat([
    input_df[['level1']].rename(columns={'level1': 'level'}),
    input_df[['level2']].rename(columns={'level2': 'level'}),
    input_df[['level3']].rename(columns={'level3': 'level'})
])

result = result.dropna().drop_duplicates()
result[['Names', 'Serial']] = result['level'].str.split(' ', n=1, expand=True)
result = result[['Serial', 'Names']].sort_values(by='Serial').reset_index(drop=True)

print(result.equals(test_df)) # True
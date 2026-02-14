import pandas as pd
import re

path = "Power Query/300-399/365/PQ_Challenge_365.xlsx"
input_df = pd.read_excel(path, usecols="A", nrows=19)
test = pd.read_excel(path, usecols="C:F", nrows=5)

df = input_df.copy()
df['event'] = df['Data'].str.extract(r'^(START|DATA|END)')
df['proc'] = (df['event'].eq('START') & df['event'].shift(fill_value='END').eq('END')).cumsum()
df['ok'] = df.groupby('proc')['Data'].transform(lambda x: x.eq('END:Success').any())
df = df.loc[df['ok']].copy()
df['ProcessID'] = df['proc'].rank(method='dense').astype("int64")

starts = df.loc[df['event'] == 'START', ['proc', 'ProcessID', 'Data']].copy()
starts['idx'] = starts.groupby('proc').cumcount() + 1
starts['User'] = starts['Data'].str.extract(r'User_([^:]+)')[0]
starts['Type'] = starts['Data'].str.extract(r'Type_([^:]+)')[0]

datas = df.loc[df['event'] == 'DATA', ['proc', 'Data']].copy()
datas['idx'] = datas.groupby('proc').cumcount() + 1
datas['Value'] = datas['Data'].str.extract(r'Value_(\d+)')[0].astype("int64")

result = (
    starts.merge(datas[['proc', 'idx', 'Value']], on=['proc', 'idx'], how='left')
    [['ProcessID', 'User', 'Type', 'Value']]
)

print(result.equals(test))
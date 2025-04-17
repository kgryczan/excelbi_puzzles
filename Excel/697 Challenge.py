import pandas as pd
from calendar import month_abbr

path = "697 Fill up or down.xlsx"
input_df = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=6)
test_df = pd.read_excel(path, usecols="D:E", skiprows=1, nrows=13).rename(columns=lambda col: col.split('.')[0])

months_df = pd.DataFrame({
    'Month': list(month_abbr)[1:13],
    'month_num': range(1, 13),
    'Quarter': ['Q' + str((i-1)//3 + 1) for i in range(1, 13)]
})

df = months_df.merge(input_df, on='Month', how='left')
df = df.sort_values('month_num')

df['Amount'] = df.groupby('Quarter')['Amount'].transform(lambda x: x.ffill().bfill()).fillna(0).astype(int)
df = df[['Month', 'Amount']].reset_index(drop=True)

print(df.equals(test_df)) # True

import pandas as pd

path = "621 Palindromic Dates in 2025.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=12)
test = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=13)

date_range = pd.date_range(start="2025-01-01", end="2025-12-31")

df = pd.DataFrame({'Date': date_range})
df['year'], df['month'], df['day'] = df['Date'].dt.year - 2000, df['Date'].dt.month, df['Date'].dt.day

df['MDY'] = df['month'].astype(str) + df['day'].astype(str) + df['year'].astype(str)
df['DMY'] = df['day'].astype(str) + df['month'].astype(str) + df['year'].astype(str)
df['YMD'] = df['year'].astype(str) + df['month'].astype(str) + df['day'].astype(str)

df_long = df.melt(id_vars=['Date'], value_vars=['MDY', 'DMY', 'YMD'], var_name='Format', value_name='Value')

df_long['Rev'] = df_long['Value'].apply(lambda x: x[::-1])
result = df_long[df_long['Value'] == df_long['Rev']].groupby('Date')['Format'].apply(lambda x: ', '.join(x)).reset_index()

print(result.equals(test)) # True
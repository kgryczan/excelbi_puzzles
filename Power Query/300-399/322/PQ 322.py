import pandas as pd
import numpy as np
from pandas.tseries.offsets import DateOffset

path = "300-399/322/PQ_Challenge_322.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=20)
test = pd.read_excel(path, usecols="E:J", nrows=11)

df = input.copy()
df['date'] = [pd.date_range(f, t) for f, t in zip(df['From Date'], df['To Date'])]
df = df.explode('date')
df = df[df['date'].dt.year == 2024]
df = df.assign(Employees=df['Employees'].str.split(', ')).explode('Employees')
df['Month'] = df['date'].dt.month_name()
df = df[df['date'].dt.weekday < 5]
result = df.groupby(['Month', 'Employees']).size().unstack(fill_value=0)
order = ['January','February','March','April','May','June','July','August','September','October','November','December']
result = result.reindex(order).fillna(0).astype(int).reset_index()
result = result[result['Month'] != 'October'].reset_index(drop=True)

print(result.equals(test)) # True
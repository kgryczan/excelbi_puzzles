import pandas as pd
from datetime import datetime

path = "639 Total Hours Per Day.xlsx"
input = pd.read_excel(path,  usecols="A:H", nrows=6)
test = pd.read_excel(path,  usecols="A:B", skiprows=8, nrows=8)

input_long = input.melt(id_vars=['Name'], var_name='Day', value_name='Hours').dropna()
input_long[['from', 'to']] = input_long.pop('Hours').str.split('-', expand=True)
input_long[['from', 'to']] = input_long[['from', 'to']].apply(lambda x: pd.to_datetime(x.str[:2] + ':' + x.str[2:], format='%H:%M'))
input_long['hours'] = (input_long['to'] - input_long['from']).dt.total_seconds() / 3600
result = input_long.groupby('Day').agg({'hours': 'sum'}).reset_index()
result.columns = ['Day', 'Total Hours']
 
print(sorted(result)==(sorted(test))) # True
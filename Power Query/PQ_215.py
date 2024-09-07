import pandas as pd
from datetime import datetime

path = "PQ_Challenge_215.xlsx"
input = pd.read_excel(path, usecols="A:E")
test = pd.read_excel(path, usecols="G:J", nrows=14)

today = pd.Timestamp(datetime.today().date())

result = input.assign(out_day=pd.Series(dtype=float))
result['out_day'] = result['Paid Date'].apply(lambda x: None if pd.isnull(x) else 0)
result['out_day'] = result['out_day'].combine_first(result['Due Date'].apply(lambda x: 0 if x > today else (today.date() - x.date()).days))
result = result[result['Paid Date'].isnull()]
result = result.sort_values(by=['Branch ID', 'Customer', 'Due Date']).reset_index(drop=True)
result = result.drop(columns=['Paid Date']).reset_index(drop=True)
result = result.set_index(['Branch ID', 'Customer'])

print(result)

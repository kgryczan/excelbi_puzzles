import pandas as pd
import numpy as np

path = "Excel/900-999/914/914 Billing Amount.xlsx"
input = pd.read_excel(path, usecols="A:D", skiprows=1, nrows=12)
test = pd.read_excel(path, usecols="F:G", skiprows=1, nrows=2).rename(columns=lambda x: x.replace('.1', ''))

def overlap(a1, a2, b1, b2):
    return np.maximum((np.minimum(a2, b2) - np.maximum(a1, b1)).total_seconds() / 3600, 0)

input['Date'] = pd.to_datetime(input['Date'], format='%d.%m.%Y', errors='coerce').fillna(
    pd.to_datetime(input['Date'], format='%Y-%m-%d', errors='coerce')
)
input = input.assign(Time=input['Time'].str.split(",")).explode('Time')
input[['s', 'e']] = input['Time'].str.split('-', expand=True)
input['s'] = pd.to_datetime(input['Date'].dt.strftime('%Y-%m-%d') + ' ' + input['s'], format='%Y-%m-%d %H:%M')
input['e'] = pd.to_datetime(input['Date'].dt.strftime('%Y-%m-%d') + ' ' + input['e'], format='%Y-%m-%d %H:%M')
input['d1'], input['d2'] = [pd.to_datetime(input['Date'].dt.strftime('%Y-%m-%d') + f' {t}', format='%Y-%m-%d %H:%M') for t in ['09:00', '17:00']]
input['tot'] = (input['e'] - input['s']).dt.total_seconds() / 3600
input['reg'] = input.apply(lambda row: overlap(row['s'], row['e'], row['d1'], row['d2']), axis=1)
input['ot'] = input['tot'] - input['reg']
input['amt'] = np.where(
    input['Date'].dt.weekday >= 5,
    input['tot'] * input['Rate'] * 1.5,
    input['reg'] * input['Rate'] + input['ot'] * input['Rate'] * 1.2
)
result = input.groupby('Resource', as_index=False).agg({'amt': 'sum'}).rename(columns={'amt': 'Billed Amount'})

print(result.equals(test))

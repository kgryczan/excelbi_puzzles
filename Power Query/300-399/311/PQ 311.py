import pandas as pd
from datetime import datetime, timedelta
import re

path = "300-399/311/PQ_Challenge_311.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=13)
test = pd.read_excel(path, usecols="F:I", nrows=10).sort_values(['Clinic', 'Patient Name']).reset_index(drop=True)

input['Clinic'] = input.apply(lambda row: row['Column2'] if row['Column1'] == 'Clinic' else None, axis=1)
input['Clinic'] = input['Clinic'].ffill()
input = input[input['Column1'] != 'Clinic'].reset_index(drop=True)
input.loc[0, 'Clinic'] = 'Clinic'
input.columns = input.iloc[0]
input = input[1:].reset_index(drop=True)

id_vars = ['Clinic', 'Patients']
value_vars = [col for col in input.columns if col not in id_vars]
df_long = input.melt(id_vars=id_vars, value_vars=value_vars, var_name='type', value_name='date')

df_long = df_long.dropna(subset=['date'])
df_last = df_long.sort_values('date').groupby('Patients').tail(1).reset_index(drop=True)

status_map = {
    'Reg': 'Registered',
    'In': 'Admitted',
    'Out': 'Discharged'
}
df_last['Status'] = [
    next((v for k, v in status_map.items() if k in str(t)), None)
    for t in df_last['type']
]

result = df_last.sort_values(['Clinic','Patients']).rename(
    columns={'Patients': 'Patient Name', 'date': 'Last Status Date'}
)[['Clinic', 'Patient Name', 'Status', 'Last Status Date']].reset_index(drop=True)

print(result)
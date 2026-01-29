import pandas as pd
import numpy as np
from datetime import timedelta

path = "Excel/900-999/902/902 Total Hours.xlsx"
input_data = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=35)
test = pd.read_excel(path, usecols="E:F", skiprows=1, nrows=4).rename(columns=lambda x: x.replace(".1", ""))
test['Total Hours'] = test['Total Hours'].round(2)

input_data[['Start', 'End']] = input_data['Timing'].str.split('-', expand=True)
input_data['Start'] = pd.to_datetime(input_data['Start'], format="%H:%M")
input_data['End'] = pd.to_datetime(input_data['End'], format="%H:%M")

input_data['Duration'] = input_data.apply(
    lambda row: (row['End'] + timedelta(days=1) if row['End'] < row['Start'] else row['End']) - row['Start'], axis=1
).dt.total_seconds() / 3600

input_data['Total Hours'] = input_data['Duration'] * \
    np.where(input_data['EmpID'].str.extract(r'(\d+)')[0].astype(int) > 150, 1.2, 1) * \
    input_data['Category'].map({"ALPHA": 1, "BETA": 1.5, "GAMMA": 2})

result = input_data.groupby('Category')['Total Hours'].sum().reset_index()
result.loc[len(result)] = ['Total', result['Total Hours'].sum()]
result['Total Hours'] = result['Total Hours'].round(2)

print(test.equals(result))
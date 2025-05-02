import pandas as pd
import numpy as np

input = pd.read_excel('PQ_Challenge_167.xlsx', usecols="A:D", nrows=14)
test = pd.read_excel('PQ_Challenge_167.xlsx', usecols="G:K", nrows=16)
test.rename(columns={'Vaccine.1': 'Vaccine', 'Camp No.1':'Camp No'}, inplace=True)

input['group_name'] = np.where(input['Camp No'].notna().cumsum() == input['Camp No'], input['Vaccine'], np.nan)
input['group_name'] = input.groupby('group_name')['group_name'].ffill()
input = input[input['Camp No'].isna()]
input = input.pivot_table(index='group_name', columns='Vaccine', values=['Notification Date', 'Administration Date'], aggfunc='first').reset_index()
input = input.melt(id_vars=['group_name'], var_name=['Event', 'Name'], value_name='Date')
input = input.pivot_table(index=['group_name', 'Name'], columns='Event', values='Date', aggfunc='first', dropna=False).reset_index()
input = input.sort_values(by=['group_name', 'Name'], ascending=[False, True])
input['Notified'] = np.where(input['Notification Date'].notna(), 'Yes', 'No')
input['Administered'] = np.where(input['Administration Date'].notna(), 'Yes', np.where(input['Notification Date'].notna(), 'No', np.nan))
input['Camp No'] = input.groupby('group_name').cumcount() + 1
input = input[['Camp No','group_name', 'Name', 'Notified', 'Administered']].reset_index(drop=True)
input.rename(columns={'group_name': 'Vaccine'}, inplace=True)

input = input.astype(str)
test = test.astype(str)

print(input.equals(test))

# Output: True
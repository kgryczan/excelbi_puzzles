import pandas as pd
import numpy as np
from datetime import datetime

path = "PQ_Challenge_224.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=11)
test = pd.read_excel(path, usecols="F:I", nrows=20)

input['date'] = np.where(input['Column1'].str.contains(r'\d'), input['Column1'], np.nan)
input['date'] = input['date'].ffill()
input.columns = ['Name', 'Data1', 'Data2', 'Data3', "Date"]

input['has_letter'] = input['Data1'].str.contains(r'[a-zA-Z]', na=False)
input = input[~input['has_letter']]

input['Date'] = pd.to_datetime(input['Date'], format='%m/%d/%Y', errors='coerce')
input.loc[:, 'Data1':'Data3'] = input.loc[:, 'Data1':'Data3'].apply(pd.to_numeric, errors='coerce')
input = input.drop(columns='has_letter')

result = (input.melt(id_vars=['Date', 'Name'], var_name='Data', value_name='Value')
               .dropna()
               .sort_values(by=['Date', 'Name', 'Data'])
               .reset_index(drop=True))
result['Value'] = result['Value'].astype('int64')

test = test.sort_values(['Date', 'Name', 'Data']).reset_index(drop=True)

print(result.equals(test)) # True

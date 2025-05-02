import pandas as pd
import numpy as np

path = "660 Insert Sum After Year Ends.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=11)
test = pd.read_excel(path, usecols="D:E", skiprows=1, nrows=14).rename(columns=lambda x: x.replace('.1', ''))

input[['Year-Quarter', 'Quarter']] = input['Year-Quarter'].str.split('-', expand=True)
result = input.groupby('Year-Quarter', as_index=False)['Amount'].sum()
result['Quarter'] = 'Q5'
result = pd.concat([input, result], ignore_index=True)
result['Year-Quarter'] = result['Year-Quarter'] + '-' + result['Quarter']
result = result.sort_values(by='Year-Quarter') 
result.loc[result['Quarter'] == 'Q5', 'Year-Quarter'] = np.NaN
result = result.drop(columns=['Quarter']).reset_index(drop=True)

print(result.equals(test)) # True
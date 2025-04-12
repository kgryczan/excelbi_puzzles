import pandas as pd
import numpy as np

path = "PQ_Challenge_277.xlsx"

input = pd.read_excel(path, usecols="A:B", nrows=10)
test = pd.read_excel(path, usecols="D:H", nrows=3).sort_values(by='Country').reset_index(drop=True)

input['country'] = input['Data1'].where(input['Data2'].isna())
input['country'] = input['country'].fillna(method='ffill')
input = input.dropna()
input['Data1'] = input['Data1'].astype(str).str.split(', ')
input['Data2'] = input['Data2'].astype(str).str.split(', ')

input = input.explode(['Data1', 'Data2']).reset_index(drop=True)
input['Data2'] = pd.to_numeric(input['Data2'], errors='coerce')
input = input.pivot(index='country', columns='Data1', values='Data2').reset_index()
input = input.rename_axis(None, axis=1)
 
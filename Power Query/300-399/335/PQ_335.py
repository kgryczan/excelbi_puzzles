import pandas as pd
import re

path = "300-399/335/PQ_Challenge_335.xlsx"
input = pd.read_excel(path, sheet_name=None, header=0)
input = pd.read_excel(path, usecols="A:F", nrows=7)
test = pd.read_excel(path, usecols="A:I", skiprows=11, nrows=4)

input['Fruits'] = input['Fruits'].ffill()
result = input.set_index(['Fruits', 'Quarters']).unstack().sort_index(axis=1, level=1)
result.columns = [f"{q}-{col}" for col, q in result.columns]
result = result.reset_index()
cols = result.columns.tolist()
result = result[['Fruits'] + sorted([c for c in cols if c != 'Fruits'], key=lambda x: x.split('-')[::-1])]
result.columns.name = None

print(result.equals(test)) # True
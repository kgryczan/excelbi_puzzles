import pandas as pd
import re
from pathlib import Path

path = "300-399/308/PQ_Challenge_308.xlsx"
input = pd.read_excel(path, usecols="B", skiprows=1, nrows=4)
test = pd.read_excel(path, usecols="D:F", skiprows=1, nrows=5)

input[['Company', 'Data']] = input['Data'].str.extract(r'(Company [A-Z])(.+)')
input['Data'] = input['Data'].str.lower().str.findall(r'[a-z]+[\s:-]*\d+')
unnested = input.explode('Data').dropna()
unnested[['Type', 'Value']] = unnested['Data'].str.extract(r'([a-z]+).*?(\d+)')
unnested = unnested[unnested['Type'] != 'year']
pivot = unnested.pivot_table(index='Company', columns='Type', values='Value', aggfunc=lambda x: x.astype(int).sum()).reset_index()
pivot.columns = [c.title() for c in pivot.columns]
totals = {col: pivot[col].astype(int).sum() if col != 'Company' else 'Total' for col in pivot.columns}
pivot = pd.concat([pivot, pd.DataFrame([totals])], ignore_index=True)[['Company', 'Revenue', 'Cost']]

print(pivot.equals(test))
# True
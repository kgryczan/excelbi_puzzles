import pandas as pd
import re

path = "200-299/287/PQ_Challenge_287.xlsx"
input = pd.read_excel(path, usecols="A", nrows=21)
test = pd.read_excel(path, usecols="C:F", nrows=4)

input.columns = ['Medal Table']

cats = ['Country', 'Country Code', 'Gold', 'Silver', 'Bronze']
input['Category'] = [cats[i % 5] if pd.notna(v) else None for i, v in enumerate(input['Medal Table'])]

input['group'] = (input['Category'] == "Country").cumsum()
pivoted = input.pivot(index='group', columns='Category', values='Medal Table').reset_index(drop=True)

for medal, pts in zip(['Gold', 'Silver', 'Bronze'], [3, 2, 1]):
    if medal in pivoted:
        pivoted[medal] = pivoted[medal].astype(str).str.extract(r'(\d+)').fillna(0).astype(int)

pivoted['Total Points'] = sum(pivoted.get(m, 0) * pts for m, pts in zip(['Gold', 'Silver', 'Bronze'], [3, 2, 1]))
result = pivoted[['Country', 'Country Code', 'Total Points']].copy()
result['Rank'] = result['Total Points'].rank(method='dense', ascending=False).astype(int)
result = result.sort_values(['Rank', 'Country']).reset_index(drop=True)
result.columns.name = None

print(result.equals(test)) # True
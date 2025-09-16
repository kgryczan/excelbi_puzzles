import pandas as pd
import numpy as np
import re

path = "800-899/805/805 Vowels in Increasing or Decreasing Order.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=15)
test = pd.read_excel(path, usecols="D:G", skiprows=1, nrows=3).rename(columns=lambda col: col.replace('.1', ''))

vowel_levels = ['a', 'e', 'i', 'o', 'u']
vowel_map = {v: i for i, v in enumerate(vowel_levels)}

input['riv'] = input['Rivers'].str.lower()
input['vowels'] = input['riv'].apply(lambda s: re.findall(r'[aeiou]', s))
input['inc'] = input['vowels'].apply(lambda v: all(np.diff([vowel_map[x] for x in v]) >= 0)) 
input['dec'] = input['vowels'].apply(lambda v: all(np.diff([vowel_map[x] for x in v]) <= 0))
input['vowel_order'] = np.select(
    [input['inc'] & ~input['dec'], ~input['inc'] & input['dec']],
    ['increase', 'decrease'],
    default='neither'
)

filtered = input[input['vowel_order'] != 'neither'].copy()
filtered = filtered[['Group', 'Rivers']].sort_values(['Group', 'Rivers'])

filtered['rn'] = filtered.groupby('Group').cumcount() + 1

result = filtered.pivot(index='Group', columns='rn', values='Rivers')
result.columns = [f"River{col}" for col in result.columns]
result = result.reset_index()
print(result.equals(test)) # True
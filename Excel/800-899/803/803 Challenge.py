import pandas as pd

file_path = "800-899/803/803 Max & Min.xlsx"

input = pd.read_excel(file_path, usecols="A:I", skiprows=1, nrows=6)
test = pd.read_excel(file_path, usecols="K:M", skiprows=1, nrows=8).rename(columns=lambda c: c.replace('.1', ''))

input_long = input.melt(id_vars='Name', var_name='Year', value_name='Value')
input_long = input_long.dropna(subset=['Value', 'Year'])
input_long = input_long.astype({'Value': int, 'Year': int})
value_range = [input_long['Value'].min(), input_long['Value'].max()]
filtered = input_long[input_long['Value'].isin(value_range)].copy()
filtered['Category'] = filtered['Value'].apply(lambda x: 'Min' if x == input_long['Value'].min() else 'Max')
filtered = filtered.sort_values(['Category', 'Name']).reset_index(drop=True)[['Category', 'Name', 'Year']]
filtered['Category'] = filtered.groupby('Category', group_keys=False).apply(
    lambda g: [g['Category'].iloc[0]] + [None]*(len(g)-1)
).explode().values

print(test.equals(filtered)) #
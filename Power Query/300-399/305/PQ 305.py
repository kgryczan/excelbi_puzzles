import pandas as pd
import numpy as np

path = "300-399/305/PQ_Challenge_305.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=14)
test = pd.read_excel(path, usecols="G:J", nrows=14).rename(columns=lambda x: x.replace('.1', ''))

input = (
    input.assign(Org=lambda df: np.where(df['Org No.'].notna(), df['Org Name'], np.nan))
    .rename(columns={'Org Name': 'Region', 'Org': 'Org Name'})
    .pipe(lambda df: df.assign(**df[['Org No.', 'Org Name']].ffill()))
    .loc[lambda df: df['Region'] != df['Org Name']]
    .assign(Profit=lambda df: (df['Sale'] - df['Cost']).astype(int))
    .filter(['Org No.', 'Org Name', 'Region', 'Profit'])
    .rename(columns={'Org No.': 'Org No'})
)

dfs = {}
for org_name, group in input.groupby('Org No'):
    group = group.copy()
    total_row = group[['Profit']].sum().rename('Total')
    total_row['Org No'] = 'TOTAL'
    total_row['Org Name'] = np.nan
    total_row['Region'] = np.nan
    group = pd.concat([group, total_row.to_frame().T], ignore_index=True)
    dfs[org_name] = group

result = pd.concat(dfs.values(), ignore_index=True)

print(result.fillna('NaN').equals(test.fillna('NaN'))) # True
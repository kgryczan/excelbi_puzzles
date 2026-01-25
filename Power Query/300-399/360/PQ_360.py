import pandas as pd
import re

path = "Power Query/300-399/360/PQ_Challenge_360.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=101)
test = pd.read_excel(path, usecols="D:H", nrows=7)

input['bracketed_substring'] = input.apply(lambda row: re.search(r'\[(.*?)\]', str(row)).group(1) if re.search(r'\[(.*?)\]', str(row)) else None, axis=1)
input['hours'] = input.apply(lambda row: float(re.search(r'\b(\d+(?:\.\d+)?)\s*(h|hr|hrs)\b', str(row), re.IGNORECASE).group(1)) if re.search(r'\b(\d+(?:\.\d+)?)\s*(h|hr|hrs)\b', str(row), re.IGNORECASE) else None, axis=1)
input['Employee'] = input.apply(lambda row: re.search(r'\|\s*(.*)', str(row)).group(1) if re.search(r'\|\s*(.*)', str(row)) else None, axis=1)
input['Employee'] = input['Employee'].str.split(', ')
input = input.explode('Employee')

summary = input.groupby(['Employee', 'bracketed_substring'])['hours'].sum().astype('int64').reset_index(drop=False)
pivot_table = summary.pivot(index='Employee', columns='bracketed_substring', values='hours').fillna(0).reset_index()
pivot_table.columns.name = None
pivot_table = pivot_table.astype({col: 'int64' for col in pivot_table.columns if col != 'Employee'})
pivot_table['Total'] = pivot_table.drop('Employee', axis=1).sum(axis=1)
total_row = pivot_table.drop('Employee', axis=1).sum()
total_row['Employee'] = 'Total'
pivot_table = pd.concat([pivot_table, total_row.to_frame().T], ignore_index=True)

print(all(pivot_table==test))
# True
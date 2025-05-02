import pandas as pd
from datetime import datetime
import locale

path = "686 Data Alignment.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=23)
test = pd.read_excel(path, usecols="E:H", skiprows=1, nrows=7)

locale.setlocale(locale.LC_TIME, "English")

input['Role_no'] = input.groupby('EmpCode')['Role'].apply(
    lambda x: (x != x.shift().fillna(x.iloc[0])).cumsum()
).reset_index(level=0, drop=True)

result = (
    input.groupby(['EmpCode', 'Role_no', 'Role'])
    .agg(
        max_date=('Date', lambda x: x.max().strftime("%b%y")),
        min_date=('Date', lambda x: x.min().strftime("%b%y"))
    )
    .reset_index()
)

result['period'] = result.apply(
    lambda row: row['min_date'] if row['max_date'] == row['min_date'] else f"{row['min_date']} to {row['max_date']}",
    axis=1
)

result = result.pivot_table(
    index='Role', 
    columns='EmpCode', 
    values='period', 
    aggfunc=lambda x: ', '.join(x)
).reset_index()

print(result)

import pandas as pd
from dateutil.relativedelta import relativedelta

path = "635 Sorting Years Month Days.xlsx"
input = pd.read_excel(path, usecols="A", nrows=8)
test = pd.read_excel(path, usecols="C", nrows=8)
input[['Year', 'Y', 'Month', 'M', 'Day', 'D']] = input['DATA'].str.split(' ', expand=True).astype(int)

def calculate_total_days(row):
    delta = relativedelta(years=row['Year'], months=row['Month'], days=row['Day'])
    return delta.years * 365 + delta.months * 30 + delta.days

input['Total_Days'] = input.apply(calculate_total_days, axis=1)
result = input.sort_values(by='Total_Days').reset_index(drop=True)

print(result['DATA'].equals(test['SORT DATA RESULTS'])) # True

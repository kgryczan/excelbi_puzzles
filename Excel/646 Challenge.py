import pandas as pd

path = "646 Insert Quarterly Total Line.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=12)
test = pd.read_excel(path, usecols="D:E", skiprows=1, nrows=17).rename(columns=lambda x: x.split('.')[0])

def insert_quarterly_totals(df):
    quarters = {'Q1': ['Jan', 'Feb', 'Mar'], 'Q2': ['Apr', 'May', 'Jun'], 
                'Q3': ['Jul', 'Aug', 'Sep'], 'Q4': ['Oct', 'Nov', 'Dec']}
    result = pd.concat([df[df['Data'].isin(months)]._append(
        {'Data': 'Quarter Total', 'Value': df[df['Data'].isin(months)]['Value'].sum()}, ignore_index=True)
        for months in quarters.values()])
    return result.reset_index(drop=True)

input_with_totals = insert_quarterly_totals(input)
print(all(input_with_totals == test)) # True
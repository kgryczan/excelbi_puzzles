import pandas as pd

path = "PQ_Challenge_280.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=20)
test = pd.read_excel(path, usecols="F:I", nrows=12)

input['Date'] = pd.to_datetime(input['Date'])
pivot = input.pivot_table(index=['Date', 'Name'], columns='Data', values='Value', aggfunc='sum').reset_index()

new = pd.concat([
    pd.DataFrame({'Date': pivot['Date'].unique(), 'Name': pivot['Date'].unique(), 'Data1': 'Data1', 'Data2': 'Data2', 'Data3': 'Data3'}),
    pivot
], ignore_index=True)

new = new.groupby(['Date', 'Name']).apply(lambda x: x.sort_values(by='Date')).reset_index(drop=True)
new = new.drop(columns=['Date']).set_axis(test.columns, axis=1)

print(new)

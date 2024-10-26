import pandas as pd

path = "PQ_Challenge_229.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=5)
test = pd.read_excel(path, usecols="F:H", nrows=16).rename(columns=lambda x: x.replace('.1', ''))
test = test.sort_values(by=['Transaction', 'Month-Year']).reset_index(drop=True)

input['From Date'] = pd.to_datetime(input['From Date'])
input['To Date'] = pd.to_datetime(input['To Date'])
input['days'] = (input['To Date'] - input['From Date']).dt.days + 1
input['daily'] = input['Amount'] / input['days']

expanded = input.assign(date_range=input.apply(lambda row: pd.date_range(row['From Date'], row['To Date']), axis=1)).explode('date_range')
expanded['Month-Year'] = expanded['date_range'].dt.strftime('%m-%y')

result = expanded.groupby(['Transaction', 'Month-Year']).agg({'daily': 'sum'}).reset_index()
result['Amount'] = result['daily'].round(0).astype("int64")
result = result.drop(columns=['daily']).sort_values(by=['Transaction', 'Month-Year']).reset_index(drop=True)

print(result.equals(test))  # True

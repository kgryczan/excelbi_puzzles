import pandas as pd

path = "Excel/800-899/895/895 Max Sales.xlsx"
input = pd.read_excel(path, usecols="A:F", skiprows=1, nrows=50)
test = pd.read_excel(path, usecols="H:J", skiprows=1, nrows=7)

input['Amount'] = input['Price'] * input['Units']
input['Quarter'] = pd.to_datetime(input['Date'])
input['Quarter'] = input['Quarter'].dt.to_period('Q').dt.start_time
input['Amount'] = input['Amount'].astype('int64')

grouped = input.groupby(['Quarter', 'SalesRep'], as_index=False)['Amount'].sum()
grouped = grouped.rename(columns={'Amount': 'Total_Sales'})

max_sales = grouped.groupby('Quarter')['Total_Sales'].transform('max')
filtered = grouped[grouped['Total_Sales'] == max_sales]

result = filtered.groupby('Quarter', as_index=False).agg({
    'SalesRep': lambda x: ', '.join(x),
    'Total_Sales': 'first'
})

result['Quarter'] = result['Quarter'].dt.to_period('Q')
result['Quarter'] = result['Quarter'].apply(lambda x: f"Q{x.quarter}-{x.year}")
result = result.rename(columns={'SalesRep': 'Name', 'Total_Sales': 'Amount'})

print(result.equals(test))
# True
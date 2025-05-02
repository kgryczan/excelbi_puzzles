import pandas as pd

path = "636 Repeat Customers in a Year.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=88)
test = pd.read_excel(path,  usecols="E:G", skiprows=1, nrows=5)

input['Year'] = pd.DatetimeIndex(input['Date']).year

repeat_customers = (input.groupby(['Year', 'Customer', 'Store'])
                    .size()
                    .reset_index(name='n')
                    .query('n > 1')
                    .groupby('Year')
                    .agg(Count=('Customer', 'nunique'),
                         Customers=('Customer', lambda x: ', '.join(sorted(x.unique()))))
                    .reset_index())

print(all(test == repeat_customers)) # True
import pandas as pd

path = "PQ_Challenge_201.xlsx"
input1 = pd.read_excel(path, usecols="A:C", skiprows=1, nrows = 5)
input2 = pd.read_excel(path, usecols="A:C", skiprows=9, nrows = 6)
test = pd.read_excel(path, usecols="E:K", nrows = 5)

i1 = input1.assign(date=input1.apply(lambda row: pd.date_range(row['Buy Date From'], row['Buy Date To'], freq='D'), axis=1)) \
          .explode('date') \
          .filter(['Buyer', 'date'])

i2 = input2.assign(**{
    'Stock Start Date': input2['Stock Start Date'].fillna(input2['Stock Start Date'].min()),
    'Stock Finish Date': input2['Stock Finish Date'].fillna(i1['date'].max())
    })
i2['date'] = i2.apply(lambda row: pd.date_range(row['Stock Start Date'], row['Stock Finish Date'], freq='D'), axis=1)
i2 = i2.explode('date').filter(['Items', 'date'])

result = pd.merge(i1, i2, on='date') \
            .assign(X='X') \
            .pivot_table(index='Buyer', columns='Items', values='X', aggfunc='first') \
            .reset_index() \
            .rename(columns={'Buyer': 'Buyer / Items'}) \
            .rename_axis(None, axis=1)
            
print(result.equals(test))  # True
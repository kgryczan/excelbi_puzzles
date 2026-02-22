import pandas as pd
import numpy as np

path = "Power Query/300-399/368/PQ_Challenge_368.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=23)
test = pd.read_excel(path, usecols="E:F", nrows=5)

input = (
    input
    .assign(
        **dict(zip(
            ['Company','Type','Detail','Time'],
            input['Transaction_Info'].str.split('|', expand=True).T.values
        )),
        **dict(zip(
            ['Leverage','Fee'],
            input['Fee_Info'].str.split(';', expand=True).T.values
        ))
    )
)

qty_price = input['Detail'].str.split('@', expand=True)
input[['Quantity','Price']] = qty_price
input[['Quantity','Price']] = input[['Quantity','Price']].apply(pd.to_numeric, errors='coerce')

input['Leverage'] = input['Leverage'].str.extract(r'(\d+)').astype(float)
fee_pct = input['Fee'].str.extract(r'(\d+\.?\d*)')[0].astype(float)

trade = input['Price'] * input['Quantity']
eff_trade = trade * input['Leverage']
fee = eff_trade * fee_pct / 100

input['Net_trade_value'] = trade + fee * np.where(input['Type'].eq('BUY'), -1, 1)

result = (
    input.groupby('Trader_ID', as_index=False)['Net_trade_value']
    .sum()
    .round(0)
)

result.loc[len(result)] = ['Total', result['Net_trade_value'].sum()]
result['Net_trade_value'] = result['Net_trade_value'].astype('int64')
result.columns = test.columns

print(result.equals(test))
# True
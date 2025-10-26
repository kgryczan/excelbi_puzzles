import pandas as pd
from pandas.tseries.offsets import MonthEnd
from dateutil.relativedelta import relativedelta

path = "300-399/334/PQ_Challenge_334.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=7).ffill()
test = pd.read_excel(path, usecols="E:H", nrows=21).rename(columns=lambda c: c.replace('.1', ''))

def yq(y, q): return pd.Timestamp(year=int(y), month={'Q1':1,'Q2':4,'Q3':7,'Q4':10}[str(q)], day=1)

input['date'] = [yq(y, q) for y, q in zip(input['Year'], input['Quarter'])]
rows = [
    {'Year': r['Year'], 'From Date': d, 'To Date': d + MonthEnd(0), 'Value': r['Value'] / 3}
    for _, r in input.iterrows() for d in [r['date'] + relativedelta(months=i) for i in range(3)]
]
result = pd.DataFrame(rows)
result[['From Date', 'To Date']] = result[['From Date', 'To Date']].astype('datetime64[ns]')
result[['Year', 'Value']] = result[['Year', 'Value']].astype(int)

print(result.equals(test)) # True
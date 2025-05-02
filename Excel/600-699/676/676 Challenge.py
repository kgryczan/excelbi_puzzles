import pandas as pd
from pandas.tseries.offsets import DateOffset

path = "676 Credit card payment amount.xlsx"
input_df = pd.read_excel(path, usecols="A:B", nrows=101)
test_df = pd.read_excel(path, usecols="E:G", nrows=14)

input_df['Date'] = pd.to_datetime(input_df['Date'])
input_df['adjusted_date'] = input_df['Date'] + pd.to_timedelta((input_df['Date'].dt.day >= 26) * 6, unit='D')
input_df = input_df[input_df['adjusted_date'].dt.year == 2025]

result = (input_df
          .assign(Quarter="Q" + input_df['adjusted_date'].dt.quarter.astype(str),
                  Month=input_df['adjusted_date'].dt.strftime('%b'),
                  MonthOrder=input_df['adjusted_date'].dt.month)
          .groupby(['Quarter', 'Month', 'MonthOrder'], as_index=False)
          .agg(Payment=('Payment', 'sum'))
          .sort_values(by=['Quarter', 'MonthOrder'])
          .drop(columns=['MonthOrder']))

total = pd.DataFrame([{'Quarter': 'Total', 'Month': None, 'Payment': result['Payment'].sum()}])
result = pd.concat([result, total], ignore_index=True)
print(result)
import pandas as pd

path = "900-999/954/954 Streak of Momemntum.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=25, skiprows=0)
test = pd.read_excel(path, usecols="C", nrows=25, skiprows=0)

input['diff'] = input['DailySales'].diff().fillna(0)
input['sign'] = input['diff'].apply(lambda x: 1 if x > 0 else (-1 if x < 0 else 0))
input['rolling_sum'] = input['sign'].rolling(window=3, min_periods=1).sum()
input['result'] = ['Up' if x == 3 else ('Down' if x == -3 else 'Neutral') for x in input['rolling_sum']]

print(input['result'].equals(test['Answer Expected']))
# True
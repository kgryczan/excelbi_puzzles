import pandas as pd
import calendar
import numpy as np

path = "541 Months Having 5 Fri Sat Sun.xlsx"
test = pd.read_excel(path)

years = np.arange(2000, 3000)
months = np.arange(1, 13)

dates = pd.DataFrame([(y, m) for y in years for m in months], columns=['year', 'month'])
dates['diy'] = dates.apply(lambda row: calendar.monthrange(row['year'], row['month'])[1], axis=1)
dates['wday'] = dates.apply(lambda row: calendar.weekday(row['year'], row['month'], 1), axis=1)
dates['date'] = dates.apply(lambda row: f"{calendar.month_abbr[row['month']]}-{row['year']}", axis=1)

filtered_dates = dates[(dates['diy'] == 31) & (dates['wday'] == 4)]
expected_answer = filtered_dates.groupby('year')['date'].apply(', '.join).reset_index()

expected_answer = expected_answer.sort_values('year').drop('year', axis=1)

print(expected_answer["date"].equals(test["Expected Answer"])) # True

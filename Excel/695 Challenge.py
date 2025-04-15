import pandas as pd
from datetime import datetime, timedelta

def monday_of_isoweek(year, week):
    return datetime(year, 1, 4) + timedelta(days=(week - 1) * 7 - (datetime(year, 1, 4).weekday()))

data = [{
    "From": monday_of_isoweek(2025, week),
    "To": monday_of_isoweek(2025, week) + timedelta(days=6),
    "Week": week
} for week in range(1, 53)]

df = pd.DataFrame(data)
df['Month'] = df['To'].dt.strftime('%b')
df['Month Week'] = df.groupby('Month').cumcount() + 1
df['From'] = df['From'].dt.strftime('%Y-%m-%d')
df['To'] = df['To'].dt.strftime('%Y-%m-%d')

result = df[['Month', 'Month Week', 'Week', 'From', 'To']].rename(columns={
    'Month Week': 'Month Week',
    'Week': 'Year Week',
    'From': 'From Date',
    'To': 'To Date'
})

print(result)

import pandas as pd

input = pd.read_excel("PQ_Challenge_188.xlsx", usecols="A:D", nrows=3)
test = pd.read_excel("PQ_Challenge_188.xlsx", usecols="F:H", nrows=11)
test.columns = test.columns.str.replace(".1", "")

result = input.assign(date=input.apply(lambda row: pd.date_range(row['From Date'], row['To Date'], freq='D'), axis=1)) \
    .explode('date') \
    .assign(days=lambda df: (df['To Date'] - df['From Date']).dt.days + 1) \
    .assign(daily=lambda df: df['Amount'] / df['days']) \
    .assign(quarter=lambda df: df['date'].dt.quarter) \
    .assign(year=lambda df: df['date'].dt.year.astype(str).str[2:4]) \
    .assign(Quarter=lambda df: 'Q' + df['quarter'].astype(str) + '-' + df['year']) \
    .groupby(['Store', 'Quarter', 'quarter', 'year']) \
    .agg(Amount=('daily', 'sum')) \
    .round(0) \
    .astype("int64") \
    .sort_values(by=['Store','year', 'quarter']) \
    .reset_index(drop=False) \
    .drop(columns=['quarter', 'year'])

print(result.equals(test)) # True
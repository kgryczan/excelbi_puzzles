import pandas as pd
from pandas.tseries.offsets import MonthEnd

path = "900-999/911/911 Billing Installments.xlsx"
input_df = pd.read_excel(path, usecols="A:E", skiprows=1, nrows=5)
test = pd.read_excel(path, usecols="G:I", skiprows=1, nrows=14)

freq_months = {"Monthly": 1, "Quarterly": 3, "Annually": 12}


def month_diff(start, end):
    return (end.year - start.year) * 12 + (end.month - start.month) + 1


rows = []
for row in input_df.itertuples(index=False):
    step = freq_months[row[3]]
    periods = -(-month_diff(row[1], row[2]) // step)
    amount = row[4] / periods
    for i in range(1, periods + 1):
        bill_date = row[1] + pd.DateOffset(months=i * step) + MonthEnd(0)
        rows.append((row[0], bill_date, amount))

result = pd.DataFrame(rows, columns=["Client Name", "Billing Date", "Installment Amount"])

print(result.equals(test))
# True

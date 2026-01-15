import pandas as pd

path = "Excel\\800-899\\892\\892 Quarterly Running Total.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows = 50, skiprows = 1)
test = pd.read_excel(path, usecols="E:F", nrows = 50, skiprows = 1)

result = (
    input
    .assign(
        Quarter = lambda df: 'Q' + ((pd.to_datetime(df['Date']).dt.month - 1) // 3 + 1).astype(str),
        amount = lambda df: df['Credit'] + df['Interest'] - df['Debit']
    )
    .assign(
        RunningTotal = lambda df: df.groupby('Quarter')['amount'].cumsum()
    )
    [['Quarter', 'RunningTotal']]
)

print(result.equals(test))
# True
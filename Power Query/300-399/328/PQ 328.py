import pandas as pd

path = "300-399/328/PQ_Challenge_328.xlsx"
input = pd.read_excel(path, nrows=5, usecols="A:K")
test = pd.read_excel(path, skiprows=8, usecols="A:D")

for col in ["Date", "Credit", "Debit"]:
    if col in input.columns and not col.endswith(".0"):
        input.rename(columns={col: f"{col}.0"}, inplace=True)

input_long = (
    pd.wide_to_long(input, stubnames=["Credit", "Debit", "Date"], i=['Cust', 'Opening Balance'], j="transaction", sep='.', suffix='.*')
    .query("Date.notna()")
    .reset_index()
)

input_long[['Credit', 'Debit']] = input_long[['Credit', 'Debit']].fillna(0)
input_long['Closing Balance'] = input_long['Opening Balance'] + input_long.groupby('Cust').apply(lambda x: (x['Credit'] - x['Debit']).cumsum()).reset_index(level=0, drop=True)
input_long['Opening Balance'] = input_long.apply(
    lambda row: row['Opening Balance'] if row['transaction'] == 0 else input_long.loc[row.name - 1, 'Closing Balance'] if row.name > 0 and input_long.loc[row.name, 'Cust'] == input_long.loc[row.name - 1, 'Cust'] else row['Opening Balance'],
    axis=1
)
result = input_long[['Cust', 'Date', 'Opening Balance', 'Closing Balance']].astype({'Opening Balance': 'int64', 'Closing Balance': 'int64'})

print(result.equals(test))  # True

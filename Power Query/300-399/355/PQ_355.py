import pandas as pd

path = "Power Query/300-399/355/PQ_Challenge_355.xlsx"
input = pd.read_excel(path, usecols="A:F", nrows=50)
test = pd.read_excel(path, usecols="H:K", nrows=4).rename(columns=lambda col: col.replace('.1', ''))

input['Quantity'] = input.apply(lambda x: x['Quantity'] if not x['IsReturn'] else -x['Quantity'], axis=1)
input['Region'] = input['Product']

result = (
    input.groupby('Region', as_index=False)
    .agg(
        **{
            'Total Quantity': ('Quantity', 'sum'),
        }
    )
)
result['Total Amount'] = (
    input.groupby('Region')
    .apply(lambda x: (x['Quantity'] * x['UnitPrice']).sum())
    .values
)
totals = pd.DataFrame({
    'Region': ['Total'],
    'Total Quantity': [result['Total Quantity'].sum()],
    'Total Amount': [result['Total Amount'].sum()]
})
result = pd.concat([result, totals], ignore_index=True)
result['Average Price'] = (result['Total Amount'] / result['Total Quantity']).round(2)

print(result.equals(test))
# Output: True
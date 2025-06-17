import pandas as pd

path = "200-299/296/PQ_Challenge_296.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=13)
test = pd.read_excel(path, usecols="G:H", nrows=7)

input = input.copy()
input['row'] = range(1, len(input) + 1)
input['row_oddity'] = (input['row'] + 1) % 2

df = input.melt(id_vars=['row', 'row_oddity'])
even = df[df['row_oddity'] == 0].reset_index(drop=True)
odd = df[df['row_oddity'] == 1]['value'].reset_index(drop=True)
result = pd.DataFrame({'Fruits': even['value'], 'Sales': pd.to_numeric(odd, errors='coerce')}).dropna()
summary = result.groupby('Fruits', as_index=False)['Sales'].sum().astype({'Sales': int}).sort_values('Fruits')
final_result = pd.concat([summary, pd.DataFrame([{'Fruits': 'Total', 'Sales': summary['Sales'].sum()}])], ignore_index=True)

print(final_result.equals(test)) ## True
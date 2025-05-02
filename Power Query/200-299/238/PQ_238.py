import pandas as pd

path = "PQ_Challenge_238.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=12)
test = pd.read_excel(path, usecols="E:F", nrows=5).rename(columns=lambda x: x.split('.')[0])

result = input.pivot_table(index='Item', columns='Status', values='Store', aggfunc='size', fill_value=0).reset_index()
def determine_size(row):
    return f"Closed-All {row['Closed']}" if row['Open'] == 0 else f"Open-All {row['Open']}" if row['Closed'] == 0 else f"Open-{row['Open']}, Closed-{row['Closed']}"

result['Status'] = result.apply(determine_size, axis=1)
result = result[['Item', 'Status']]
result = result.rename_axis(None, axis=1)

print(result.equals(test)) # True
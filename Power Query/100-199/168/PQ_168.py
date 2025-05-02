import pandas as pd

# Read input data
input_data = pd.read_excel('PQ_Challenge_168.xlsx', sheet_name='Sheet1', usecols='A:B', nrows=10)
test_data = pd.read_excel('PQ_Challenge_168.xlsx', sheet_name='Sheet1', usecols='D:E', nrows=10)

# Sort input data
input_sorted = input_data.sort_values(by=['Store', 'Item']).reset_index(drop=True)
input_sorted['RowNumber'] = input_sorted.groupby('Store').cumcount() + 1

# Pivot table
pivot_table = input_sorted.pivot(index='Store', columns='RowNumber', values='Item')
pivot_table.columns = pivot_table.columns.astype(str)
pivot_table['string'] = pivot_table.apply(lambda x: '/'.join(x.dropna().astype(str)), axis=1)

# Merge data
result = pd.merge(input_sorted[['Store', 'RowNumber']], pivot_table, on='Store', how='left')
result['processed_string'] = result.apply(lambda x: x['string'][:(2 * x['RowNumber'] - 1)], axis=1)
result = result.rename(columns={'processed_string': 'Item'})
result = result[['Store', 'Item']]

# Rename columns in test data
test_data.rename(columns={'Store.1': 'Store', 'Item.1': 'Item'}, inplace=True)

# Check if result equals test data
print(result.equals(test_data)) # Output: True
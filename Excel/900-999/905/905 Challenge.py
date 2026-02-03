import pandas as pd

path = "Excel/900-999/905/905 Maxed Priced Houses.xlsx"
input_data = pd.read_excel(path, usecols="A:D", skiprows=1, nrows=50)
test_data = pd.read_excel(path, usecols="F:I", skiprows=1, nrows=4)

max_priced_houses = (
    input_data.groupby(['Zone', 'Type'], group_keys=False)
    .apply(lambda group: group[group['Listed Price'] == group['Listed Price'].max()])
)
summarized = (
    max_priced_houses
    .groupby(['Zone', 'Type', 'Listed Price'], as_index=False)
    .agg(Houses=('House ID', lambda x: ", ".join(map(str, x))))
)
result = (
    summarized.drop(columns=['Listed Price'])
    .pivot(index='Zone', columns='Type', values='Houses')
    .reset_index()
    .rename(columns={'Zone': 'Zone-Type'})
    .sort_values(by='Zone-Type')
    .reset_index(drop=True)
)
result.columns.name = None  
print(result.equals(test_data))
# one inconsistency due to different ordering of house IDs in a cell
import pandas as pd

path = "PQ_Challenge_275.xlsx"

input = pd.read_excel(path, usecols="A:E", nrows=7)
test = pd.read_excel(path, usecols="G:I", nrows=7)

input["id"] = input.index
result = pd.wide_to_long(input, stubnames=['Number', 'Value'], i=['id', 'Group'], j='index', sep='', suffix='\\d+').reset_index()
result = result.drop(columns=['id']).groupby('Number').agg(
    Value=('Value', 'sum'),
    Group=('Group', lambda x: ','.join(x.unique()))
).sort_values('Number').reset_index()

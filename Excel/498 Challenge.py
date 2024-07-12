import pandas as pd

path = "498 Soccer Champions Alignment.xlsx"
input = pd.read_excel(path, usecols= "A:B", skiprows= 1, nrows = 8)
test = pd.read_excel(path, usecols= "D:E", skiprows= 1)

result = input.copy()
result['Years'] = result['Years'].str.split(', ')
result = result.explode('Years').astype({'Years': 'int64'})\
    .sort_values('Years', ascending=False).reset_index(drop= True)\
    .rename(columns = {'Years': 'Year', 'Winners': 'Winner'})\
    .reindex(columns = ['Year', 'Winner'])

print(result.equals(test)) # True
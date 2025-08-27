import pandas as pd

path = "700-799/791/791 Non-Overlapping Delay.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=8)
test = pd.read_excel(path, usecols="E:F", skiprows=1, nrows=8)

input['Delay Start'] = pd.to_datetime(input['Delay Start'])
input['Delay End'] = pd.to_datetime(input['Delay End'])
input['Dates'] = input.apply(lambda r: pd.date_range(r['Delay Start'], r['Delay End']), axis=1)

all_dates = pd.DatetimeIndex([])
nod = []
for dates in input['Dates']:
    new_dates = dates.difference(all_dates)
    nod.append(len(new_dates))
    all_dates = all_dates.union(dates)

input['Delay Period'] = input['Dates'].apply(len)
input['Non-Overlapping delay'] = nod

result = input[['Delay Period', 'Non-Overlapping delay']]

print(result.equals(test))

import pandas as pd

path = "800-899/824/824 Group By Consecutive Dates.xlsx"

input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=14)
test = pd.read_excel(path, usecols="D:E", skiprows=1, nrows=4)

input['Dates'] = pd.to_datetime(input['Dates'])
input['group'] = (input['Dates'].diff().dt.days.gt(1)).cumsum()
result = (
    input.groupby('group')
    .agg(DateRange=('Dates', lambda g: f"{g.min().date()}" if g.min() == g.max() else f"{g.min().date()} To {g.max().date()}"),
         Total=('Value', 'sum'))
    .rename(columns={'DateRange': 'Date Range'})
    .reset_index(drop=True)
)
print(result.equals(test)) # True
import pandas as pd

path = "Excel/800-899/894/894 Split Stack.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=20)
test = pd.read_excel(path, usecols="C:E", skiprows=1, nrows=32)

split = input['TicketID,Items,Costs'].str.split(',', n=2, expand=True)
split.columns = ['TicketID', 'Items', 'Costs']
split = split.assign(
    Items=split['Items'].str.split('|'),
    Costs=split['Costs'].str.split('|')
).explode(['Items', 'Costs'])
split['TicketID'] = pd.to_numeric(split['TicketID'], errors='coerce')
split['Costs'] = pd.to_numeric(split['Costs'], errors='coerce')
result = split.reset_index(drop=True)

print(result.equals(test))
# True
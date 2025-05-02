import pandas as pd

path = "558 Unpack Dictionary.xlsx"
input = pd.read_excel(path, usecols="A", skiprows = 1)
test  = pd.read_excel(path, usecols="B:C", skiprows = 1)

input['rn'] = input.index + 1
input = input.assign(Dictionary=input['Dictionary'].str.split(', ')).explode('Dictionary')
input[['Key', 'Value']] = input['Dictionary'].str.split(':|;', expand=True, n=1)
result = input.groupby('rn').agg({'Key': ', '.join, 'Value': ', '.join}).reset_index(drop=True)[['Key', 'Value']]

print(result.equals(test)) # True
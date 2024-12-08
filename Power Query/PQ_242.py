import pandas as pd

path = "PQ_Challenge_242.xlsx"
input = pd.read_excel(path, usecols="A:F", nrows=4)
test = pd.read_excel(path, usecols="H:I", nrows=16).astype(str)
test['Column2'] = test['Column2'].str.replace(' 00:00:00', '')

input = input.astype(str)
input['Hall'] = input.groupby('Hall').cumcount().add(1).astype(str).radd(input['Hall'] + "_")

result = input.stack().reset_index()
result = result[~result[0].str.endswith('_2') & (result[0] != "nan")]
result.columns = ['Row', 'Column1', 'Column2']
result.drop(columns=['Row'], inplace=True)
result['Column2'] = result['Column2'].str.replace('_1', '')
result.reset_index(drop=True, inplace=True)


print(result.equals(test)) # True

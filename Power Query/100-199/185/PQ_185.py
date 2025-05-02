import pandas as pd
input = pd.read_excel("PQ_Challenge_185.xlsx", sheet_name="Sheet1", usecols="A:B")
test = pd.read_excel("PQ_Challenge_185.xlsx", sheet_name="Sheet1", usecols="D:F")
test.columns = test.columns.str.replace('.1', '')

input['Index'] = input.groupby('Group ')['Emp'].transform(lambda x: pd.factorize(x)[0]+1)

print(input.equals(test)) # True
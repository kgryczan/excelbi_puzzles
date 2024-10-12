import pandas as pd

path = "PQ_Challenge_225.xlsx"

input = pd.read_excel(path, usecols="A:D", nrows=8)
test = pd.read_excel(path, usecols="F:G", nrows=12)

input['Id'] = input['Group'].ne(input['Group'].shift()).cumsum().astype(str)
input['Group'] = input['Group'].replace('Group A', 'GroupA')

r1_1 = input.iloc[:, [0, 1, 4]].rename(columns={input.columns[0]: 'Column1', input.columns[1]: 'Column2', 'Id': 'ID'})
r1_2 = input.iloc[:, [3, 2, 4]].rename(columns={input.columns[3]: 'Column1', input.columns[2]: 'Column2', 'Id': 'ID'})

r2 = pd.concat([r1_2, r1_1]).sort_values(by='ID').drop_duplicates().drop(columns='ID').reset_index(drop=True)

print(r2.equals(test)) # True

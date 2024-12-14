import pandas as pd

path = "PQ_Challenge_243.xlsx"
input = pd.read_excel(path,usecols="A:B", nrows=9)
test = pd.read_excel(path, usecols="D:G", nrows=12).rename(columns=lambda x: x.split('.')[0])

input['Group_2'] = input.groupby('Emp ID').cumcount().add(1).astype(str).radd('Group')
input = input.sort_values('Emp ID').assign(Group=input['Group'].str.split(', ')).explode('Group')
input['x'] = input.groupby(['Emp ID', 'Group_2']).cumcount().add(1)

pivot_table = input.pivot_table(index=['Emp ID', 'x'], columns='Group_2', values='Group', aggfunc='first')
pivot_table = pivot_table.reset_index().drop(columns='x').rename_axis(None, axis=1)

print(pivot_table.equals(test)) # True
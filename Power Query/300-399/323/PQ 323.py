import pandas as pd

file_path = "300-399/323/PQ_Challenge_323.xlsx"

input_data = pd.read_excel(file_path, usecols="A", nrows=3)
test = pd.read_excel(file_path, usecols="C:F", nrows=9)

data, names, depts = [input_data.iloc[i, 0].split(',') for i in range(3)]
data = [x.strip() for x in data]
names = [x.strip() for x in names]
depts = [x.strip() for x in depts]

groups, emp_ids = [], {}
for x in data:
    if x.startswith('Group'):
        groups.append(x)
        emp_ids[x] = []
    else:
        emp_ids[groups[-1]].append(int(x))

name_dict = dict(enumerate(names, 1))
dept_dict = dict(zip(groups, depts))

df = pd.DataFrame([
    {'Group': g, 'Emp ID': eid, 'Name': name_dict[eid], 'Dept': dept_dict[g]}
    for g in groups for eid in emp_ids[g]
])
print(df.equals(test)) # True
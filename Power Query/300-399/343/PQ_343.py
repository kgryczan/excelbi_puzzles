import pandas as pd

path = "Power Query/300-399/343/PQ_Challenge_343.xlsx"
input_df = pd.read_excel(path, usecols="A:B", nrows=19)
test_df = pd.read_excel(path, usecols="D:H", nrows=5)

input_df['group'] = (input_df['Data1'] == "Dept").cumsum()
input_df = input_df[input_df['group'] > 0]

result_rows = []
for group_id, group in input_df.groupby('group'):
    emp_rows = group.index[group['Data1'] == "Emp ID"][0] + 1
    salary_rows = group.index[group['Data1'] == "Salary"][0] + 1
    n_emps = salary_rows - emp_rows

    dept = group['Data1'].iloc[1]
    emp_ids = input_df.loc[emp_rows:emp_rows + n_emps - 1, 'Data1'].tolist()
    locations = input_df.loc[emp_rows:emp_rows + n_emps - 1, 'Data2'].tolist()
    salaries = pd.to_numeric(input_df.loc[salary_rows:salary_rows + n_emps - 1, 'Data1'], errors='coerce').tolist()
    ages = pd.to_numeric(input_df.loc[salary_rows:salary_rows + n_emps - 1, 'Data2'], errors='coerce').tolist()

    for eid, loc, sal, age in zip(emp_ids, locations, salaries, ages):
        result_rows.append({
            'Dept': dept,
            'Emp ID': eid,
            'Location': loc,
            'Salary': sal,
            'Age': age
        })

result_df = pd.DataFrame(result_rows).dropna()
result_df['Salary'] = result_df['Salary'].astype('int64')
result_df['Age'] = result_df['Age'].astype('int64')
result_df = result_df.reset_index(drop=True)

print(result_df.equals(test_df)) # True
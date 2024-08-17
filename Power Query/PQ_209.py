import pandas as pd

path = "PQ_Challenge_209.xlsx"
input1 = pd.read_excel(path, usecols="A:C", skiprows=1, nrows = 8)
input2 = pd.read_excel(path, usecols="A:C", skiprows=12, nrows = 4)
test  = pd.read_excel(path, usecols="F:J", nrows = 4)
test.columns = test.columns.str.replace('.1', '')

input1['process_part'] = input1.groupby('Process').cumcount() + 1
input1['Task'] = input1['Task'].str.split(', ')
input1 = input1.explode('Task')
i1 = input1.merge(input2, on='Task', how='left')
i1['max_dur'] = i1.groupby(['Process', 'process_part'])['Duration Days'].transform('max')
i1['end_date'] = pd.to_datetime(i1['Start Date']) + pd.to_timedelta(i1['max_dur'], unit='D')
i1 = i1.pivot_table(index='Process', columns='Owner', values='end_date', aggfunc='first').reset_index()
i1 = i1[['Process', 'Anne', 'Lisa', 'Nathan', 'Robert']]
i1.columns.name = None

print(i1.equals(test)) # True
import pandas as pd

path = "PQ_Challenge_228.xlsx"
input = pd.read_excel(path, header=None, usecols="A:H", nrows=5)
test = pd.read_excel(path, usecols="J:M", nrows=20).sort_values(by=['Category','Student', 'Value']).reset_index(drop=True)

t_input = input.T
t_input.columns = t_input.iloc[0]
t_input = t_input.drop(t_input.index[0]).reset_index(drop=True)
t_input.columns = ['Category', 'Value', 'X', 'Y', 'Z']
t_input['Category'] = t_input['Category'].ffill()
t_input = t_input.melt(id_vars=['Category', 'Value'], var_name='Student', value_name='Marks')
t_input = t_input[['Student', 'Category', 'Value', 'Marks']].dropna().sort_values(by=['Category','Student', 'Value']).reset_index(drop=True)
t_input['Marks'] = t_input['Marks'].astype("int64")

print(t_input.equals(test)) # True

import pandas as pd

path = "PQ_Challenge_262.xlsx"
input = pd.read_excel(path, usecols="A:J", nrows=5)
test = pd.read_excel(path, usecols="A:C", skiprows=9, nrows=11)

df = input.reset_index().rename(columns={'index': 'id'})
df_long = df.melt(id_vars='id', var_name='Category', value_name='Value')
df_long[['Type', 'Subject']] = df_long['Category'].str.split('-', expand=True)
df_final = df_long.pivot_table(index=['id', 'Subject'], columns='Type', values='Value', dropna=False).reset_index()
df_final = df_final.dropna(subset=['Marks', 'Class'])[['Class', 'Subject', 'Marks']].astype({'Marks': 'int64', 'Class': 'int64'}).reset_index(drop=True)

print(df_final.equals(test)) # True
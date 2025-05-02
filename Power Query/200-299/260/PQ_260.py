import pandas as pd

path = "PQ_Challenge_260.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=16)
test = pd.read_excel(path, usecols="E:N", nrows=3).astype(str).applymap(lambda x: x.replace('.0', ''))
names_ = list(test.columns)

df_sum = (
    input
    .groupby(['Group', 'Dept'], as_index=False)
    .agg({'Team': lambda x: ", ".join(x.astype(str)) if len(x) > 1 else x.iloc[0]})
    .sort_values('Team', key=lambda x: x.astype(str))
)
df_sum['rn'] = df_sum.groupby('Group').cumcount() + 1

r1_left = df_sum.pivot(index='rn', columns=['Group', 'Dept'], values='Team').reset_index()
r1_left.columns = ['rn'] + [f"{g}  {d}" for g, d in r1_left.columns[1:]]
r1_right = df_sum.drop(columns='Team').pivot(index='rn', columns='Group', values='Dept').reset_index()
r1_merge = pd.merge(r1_left, r1_right, on='rn').drop(columns='rn').rename(columns=lambda x: x[3:].strip() if len(x) > 2 else x)
r1_final = r1_merge[[col for col in names_ if col in r1_merge.columns]].astype(str)

print(r1_final.equals(test)) # True
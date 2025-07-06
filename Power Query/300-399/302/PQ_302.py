import pandas as pd

path = "300-399/302/PQ_Challenge_302.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=12)
test = pd.read_excel(path, usecols="E:F", nrows=13)

input[['Country', 'State']] = input[['Country', 'State']].ffill()
input['Country_State_Order'] = input.groupby(['Country', 'State'], sort=False).ngroup()

result = (
    input
    .groupby(['Country', 'State', 'Country_State_Order'], as_index=False)
    .agg({'Cities': lambda x: ', '.join(x.dropna().astype(str))})
    .sort_values('Country_State_Order')
    .reset_index(drop=True)
)

dfs = []
for idx, row in result.iterrows():
    df = pd.DataFrame({
        'Data1': result.columns,
        'Data2': row.values
    })
    dfs.append(df)

final_df = pd.concat(dfs, ignore_index=True)
final_df = final_df[final_df['Data1'] != 'Country_State_Order'].drop_duplicates().reset_index(drop=True)

print(final_df.equals(test))
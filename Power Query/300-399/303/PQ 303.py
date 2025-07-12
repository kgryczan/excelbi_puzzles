import pandas as pd

path = "300-399/303/PQ_Challenge_303.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="C:H", nrows=4).fillna("").assign(**{'Employee ID': lambda df: df['Employee ID'].astype(str)})
test.columns = test.columns.str.strip()

pairs = (
    input['Travel Data']
    .str.split(', ').explode().str.split(': ', expand=True)
    .rename(columns={0:'key', 1:'val'})
    .assign(emp=lambda d: d.key.eq('Employee ID').cumsum(),
            day=lambda d: d.groupby('emp').key.transform(lambda s: s.eq('Date').cumsum()))
)

wide = (
    pairs.pivot_table(index=['emp','day'], columns='key', values='val', aggfunc='first')
    .reset_index(drop=True)
)

for col in ['Hotel', 'Per Diem', 'Transport']:
    wide[col] = pd.to_numeric(wide[col].replace('', 0).fillna(0))
wide[['Employee ID', 'Employee Name']] = wide[['Employee ID', 'Employee Name']].ffill()

res = (
    wide.groupby('Employee ID', as_index=False)
    .agg({'Employee Name': 'first', 'Hotel': 'sum', 'Per Diem': 'sum', 'Transport': 'sum'})
)
res = res.sort_values(by='Employee ID', ascending=False).reset_index(drop=True)
res['Total'] = res[['Hotel', 'Per Diem', 'Transport']].sum(axis=1).astype(int)
res = pd.concat([res, pd.DataFrame([{
    'Employee ID': 'Total',
    'Employee Name': '',
    'Hotel': res['Hotel'].sum(),
    'Per Diem': res['Per Diem'].sum(),
    'Transport': res['Transport'].sum(),
    'Total': res['Total'].sum()
}])], ignore_index=True)

print(res.equals(test))

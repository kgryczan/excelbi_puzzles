import pandas as pd

path = "300-399/304/PQ_Challenge_304.xlsx"
input = pd.read_excel(path, usecols="A:F", nrows=9)
test  = pd.read_excel(path, usecols="A:I", skiprows=13, nrows=5)

result = (
    input.ffill()
    .melt(id_vars=['Persons', 'Category'], var_name='Quarter', value_name='Value')
    .assign(Category_Quarter=lambda d: d['Category'] + '-' + d['Quarter'])
    .pivot(index='Persons', columns='Category_Quarter', values='Value')
    .reset_index()
)
result.update(result.filter(like='Q').sub(result.filter(like='Q').shift(fill_value=0)))
result['Persons'] = result['Persons'].astype(str).str[-1]
result.columns.name = None
ordered_cols = ['Persons'] + [f"{cat}-{qtr}" for qtr in ['Q1','Q2','Q3','Q4'] for cat in ['Sales','Bonus'] if f"{cat}-{qtr}" in result.columns]

result = result[ordered_cols]

print(result.equals(test))
import pandas as pd

path = "200-299/293/PQ_Challenge_293.xlsx"
input = pd.read_excel(path, header=None, nrows=6, usecols="A:J")
test = pd.read_excel(path, header=0, skiprows=9, nrows=6, usecols="A:J")

col_names = [
    f"{input.iloc[0, i]}-{input.iloc[1, i]}" if pd.notna(input.iloc[0, i]) else input.iloc[1, i]
    for i in range(input.shape[1])
]
clean = input.iloc[2:].copy()
clean.columns = col_names
clean = clean.apply(pd.to_numeric, errors='ignore')

q_cols = [c for c in clean.columns if str(c).lower().startswith('q')]
summary = {'Country': 'Total', 'Capital': 'EU', **{col: clean[col].sum() for col in q_cols}}
total = pd.concat([clean, pd.DataFrame([summary])], ignore_index=True)

cols = ['Country', 'Capital'] + sorted([c for c in total.columns if c.startswith(('Q1', 'Q2', 'Q3', 'Q4'))])
total = total[cols]

print(total.equals(test))

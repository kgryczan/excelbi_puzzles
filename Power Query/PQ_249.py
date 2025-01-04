import pandas as pd

path = "PQ_Challenge_249.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=7)
test = pd.read_excel(path, usecols="A:E", skiprows=10, nrows=4)

r1 = (input.assign(rn=input.groupby('Class').cumcount() + 1)
    .pivot(index='Class', columns='rn', values='Student')
    .reset_index()
    .rename(columns=lambda x: f'Student{x}' if isinstance(x, int) else x))

r2 = (input.groupby(['Class', 'Marks'])['Student']
    .apply(lambda x: ', '.join(x))
    .reset_index()
    .sort_values('Marks', ascending=False)
    .drop_duplicates('Class')
    .rename(columns={'Student': 'Best Student'})
    .drop(columns='Marks'))

result = r1.merge(r2, on='Class')

print(result.equals(test))
# True
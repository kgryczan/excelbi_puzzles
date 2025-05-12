import pandas as pd

path = "700-799/714/714 Sell Alignment.xlsx"

input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=11)
test = pd.read_excel(path, usecols="D:F", skiprows=1, nrows=3).rename(columns=lambda c: c.replace('.1', ''))

input['Instr'] = input['Produce'].str.endswith('N').map({True: "Don't Sell", False: "Sell"})
input['Produce'] = input['Produce'].str.extract(r'^(\w+)')

result = (
    input.groupby(['Farmer', 'Instr'])['Produce']
    .apply(lambda x: ', '.join(sorted(x.dropna())))
    .unstack()
    .reset_index()[['Farmer', 'Sell', "Don't Sell"]]
    .sort_values('Farmer')
    .reset_index(drop=True)
)
print(result.equals(test)) # True
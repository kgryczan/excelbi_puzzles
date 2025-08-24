import pandas as pd

path = "300-399/316/PQ_Challenge_316.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=17)
test = pd.read_excel(path, usecols="E:H", nrows=7).rename(columns=lambda c: c.replace('.1', ''))

input['Continent'] = input['Continent'].ffill()
input['row_in_continent'] = input.groupby('Continent').cumcount() + 1
input['r'] = ((input['row_in_continent'] + 2) // 3)
input['Country'] = input['Country'] + '-' + input['Medals'].astype(str)
input['nr'] = input.groupby(['Continent', 'r']).cumcount() + 1

result = (
    input
    .pivot_table(index=['Continent', 'r'], columns='nr', values='Country', aggfunc='first')
    .reset_index()
)

result.columns = ['Continent', 'r'] + [f'Country{col}' for col in result.columns[2:]]
result = result.drop(columns='r')
result = result[result.columns[:len(test.columns)]]

print(result)
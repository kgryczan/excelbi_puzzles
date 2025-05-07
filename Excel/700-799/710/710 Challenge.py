import pandas as pd
from itertools import product

path = "700-799/710/710 Combination.xlsx"
input_df = pd.read_excel(path, usecols="A:B", nrows=4)
input2 = pd.read_excel(path, usecols="D", nrows=2).iloc[:, 0].iloc[0]
test = pd.read_excel(path, usecols="F", nrows=4)

prices = dict(zip(input_df['Item'], input_df['Price']))

combinations = [
    (bread, snak, drink)
    for bread, snak, drink in product(
        range(1, int(input2 / prices['Bread']) + 1),
        range(1, int(input2 / prices['Snak']) + 1),
        range(1, int(input2 / prices['Drink']) + 1)
    )
    if prices['Bread'] * bread + prices['Snak'] * snak + prices['Drink'] * drink == input2
]

result = pd.DataFrame({
    'Result': [f"Bread {bread}, Snak {snak}, Drink {drink}" for bread, snak, drink in combinations]
})

print(result['Result'].tolist() == test.iloc[:, 0].tolist())


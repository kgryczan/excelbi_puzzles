import pandas as pd
import itertools

path = "600 Smallest Coin Sums.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10)

def find_lowest_impossible_sum(coins):
    coins = list(map(int, coins.split(',')))
    all_combinations = {sum(comb) for r in range(1, len(coins) + 1) for comb in itertools.combinations(coins, r)}
    return next(i for i in range(1, sum(coins) + 2) if i not in all_combinations)

input['result'] = input['Coins'].apply(find_lowest_impossible_sum)
result = input[['result']]

print(result['result'].equals(test['Answer Expected'])) # True
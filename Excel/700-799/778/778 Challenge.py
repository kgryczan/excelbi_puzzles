import pandas as pd

path = "700-799/778/778 Coin Change.xlsx"
input1 = pd.read_excel(path, usecols="A", skiprows=1, nrows=8)
input2 = pd.read_excel(path, usecols="B:H", nrows=1, header=None, skiprows=1).values.flatten()
test = pd.read_excel(path, usecols="B:H", skiprows=1, nrows=8).fillna(0).astype(int)

def find_coin_comb(amount, coins):
    coins = sorted(coins, reverse=True)
    coin_count = {coin: 0 for coin in coins}
    for coin in coins:
        if amount >= coin:
            count = amount // coin
            amount = amount % coin
            coin_count[coin] = count
    return coin_count

results = []
for amt in input1.iloc[:, 0]:
    comb = find_coin_comb(amt, input2)
    results.append(comb)

result_df = pd.DataFrame(results)[input2]

print(result_df)
print(test)
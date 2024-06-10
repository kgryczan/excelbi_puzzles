import pandas as pd

input = pd.read_excel("474 Wavy Numbers.xlsx", usecols="A", nrows=10)
test = pd.read_excel("474 Wavy Numbers.xlsx", usecols="B", nrows=5)

def is_wavy(number):
    digits = [int(d) for d in str(number)]
    differences = [digits[i+1] - digits[i] for i in range(len(digits)-1)]
    signs = [1 if diff > 0 else -1 if diff < 0 else 0 for diff in differences]
    if len(signs) < 2:
        return False
    return all(abs(signs[i+1] - signs[i]) == 2 for i in range(len(signs)-1))

result = input[input['Numbers'].apply(is_wavy)][['Numbers']]\
    .rename(columns={'Numbers': 'Answer Expected'})\
    .reset_index(drop=True)

print(result.equals(test)) # True
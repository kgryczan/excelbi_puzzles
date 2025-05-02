import pandas as pd
from itertools import combinations

path = "588 Minimum Sum Pair.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=10)
test = pd.read_excel(path, usecols="F", nrows=4).values.flatten().tolist()

def process_column(column):
    comb = pd.DataFrame(combinations(column, 2), columns=['X1', 'X2'])
    min_sum_pair = comb.assign(sum=comb['X1'] + comb['X2']).nsmallest(1, 'sum')
    return f"{min_sum_pair.iloc[0]['X1']}, {min_sum_pair.iloc[0]['X2']}"

result = [process_column(input[col]) for col in input.columns]

print(result == test) # True
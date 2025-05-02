import pandas as pd

path = "551 Watson-Crick Palindromes.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10)

def compliment(x):
    return x.replace({"A": "T", "T": "A", "C": "G", "G": "C"}).fillna("N")

input['nchar'] = input['String'].str.len()
input['pos'] = input['String'].str.find('X')
input['char'] = input.apply(lambda row: row['String'][row['nchar'] - row['pos'] - 1], axis=1)
input['compliment'] = compliment(input['char'])

result = input[['compliment']].rename(columns={'compliment': 'Answer Expected'})

print(result.equals(test)) # True
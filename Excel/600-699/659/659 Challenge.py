import pandas as pd

path = "659 Cube Frequency of All Digits Same.xlsx"
test = pd.read_excel(path, usecols="A", nrows=81)

def find_numbers(min_n=10, max_n=99999):
    return pd.DataFrame(
        [num for num in range(min_n, max_n + 1) 
         if len(set(str(num ** 3).count(digit) for digit in set(str(num ** 3)))) == 1], 
        columns=["Answer Expected"]
    )

result = find_numbers()

print(result.equals(test)) # True
import pandas as pd

path = "585 List the Factorials.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=10)
test = pd.read_excel(path, usecols="B:C", skiprows=1, nrows=5)

def is_factorial(n):
    if n < 1:
        return False
    factorial = 1
    i = 1
    while factorial < n:
        i += 1
        factorial *= i
    return factorial == n

def factorial_of(n):
    if n < 1:
        return None
    factorial = 1
    i = 1
    while factorial < n:
        i += 1
        factorial *= i
    return i if factorial == n else None

input['is_fact'] = input.iloc[:, 0].apply(is_factorial)
result = input[input['is_fact']].copy()
result['Factorial Of'] = result.iloc[:, 0].apply(factorial_of)
result = result.drop(columns=['is_fact']).reset_index(drop=True)
result.columns = ['Number', 'Factorial Of']

print(result.equals(test)) # True
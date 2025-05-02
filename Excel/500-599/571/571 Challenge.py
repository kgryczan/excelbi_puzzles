import pandas as pd

path = "571 Product of Number and its revese.xlsx"
input = pd.read_excel(path)

result = [n for n in range(10, 1200000) if set(str(n)) == set(str(int(str(n)[::-1]) * n))][:500]

print(input["Answer Expected"].equals(pd.Series(result)))   # True
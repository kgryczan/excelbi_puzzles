import pandas as pd

path = "516 Product of Digits of Result is Equal to Number.xlsx"
input = pd.read_excel(path, usecols="A")
test  = pd.read_excel(path, usecols="B")

def find_smallest_number_with_digit_product(n):
    if n == 0:
        return 10
    if n == 1:
        return 1
    
    factors = []
    
    for i in range(9, 1, -1):
        while n % i == 0:
            factors.append(i)
            n //= i
    
    return int(''.join(map(str, sorted(factors)))) if n == 1 else "NP"

result = [find_smallest_number_with_digit_product(n) for n in input["Number"]]
result_df = pd.DataFrame(result, columns=["Answer Expected"])
print(result_df.equals(test))   # True
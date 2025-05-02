import pandas as pd

path = "522 Express as Sum of Consecutive Odd Numbers.xlsx"
input = pd.read_excel(path, usecols="A")
test  = pd.read_excel(path, usecols="B")

def find_sum_consecutive(n):
    odd_numbers = list(range(1, n, 2))
    for start in range(len(odd_numbers)):
        for length in range(2, len(odd_numbers) - start + 1):
            end = start + length - 1
            if end > len(odd_numbers):
                break
            current_sum = sum(odd_numbers[start:end])
            if current_sum == n:
                return ', '.join(map(str, odd_numbers[start:end]))
            if current_sum > n:
                break
    return "NP"

input['Answer Expected'] = input.apply(lambda x: find_sum_consecutive(x['Number']), axis=1)

print(input["Answer Expected"].equals(test["Answer Expected"])) # True
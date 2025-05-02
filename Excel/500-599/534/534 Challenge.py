import pandas as pd

path = "534 Palindrome Numbers with Digit Repeations.xlsx"
input = pd.read_excel(path, usecols="A:B")
test = pd.read_excel(path, usecols="C:E", names=["res1", "res2", "res3"])

def is_palindrome(n):
    return str(n) == str(n)[::-1]

def has_repeated_digits(n, times):
    return any(str(n).count(d) == times for d in str(n))

def find_next_palindromic_numbers(start_number, repeats):
    found_numbers = []
    num = start_number + 1
    while len(found_numbers) < 3:
        if is_palindrome(num) and has_repeated_digits(num, repeats):
            found_numbers.append(num)
        num += 1
    return found_numbers

output = input.apply(lambda x: find_next_palindromic_numbers(x["No. of Digits"], x["Repeats"]), axis=1)
output = output.apply(pd.Series)
output.columns = ["res1", "res2", "res3"]
output = output.astype("int64")

print(output.equals(test))

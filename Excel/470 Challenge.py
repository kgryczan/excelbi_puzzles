import pandas as pd

input = pd.read_excel("469 Next Greater Number with Same Digits.xlsx", sheet_name="Sheet1", usecols="A")
test  = pd.read_excel("469 Next Greater Number with Same Digits.xlsx", sheet_name="Sheet1", usecols="B")

def find_greater_from_same_digits(number):
    number = str(number)
    n = len(number)
    number_splitted = list(map(int, list(number)))
    i = n - 2
    while i >= 0:
        if number_splitted[i] < number_splitted[i + 1]:
            break
        i -= 1
    if i == -1:
        return "No such number"
    j = n - 1
    while j > i:
        if number_splitted[j] > number_splitted[i]:
            break
        j -= 1
    number_splitted[i], number_splitted[j] = number_splitted[j], number_splitted[i]
    number_splitted = number_splitted[:i+1] + number_splitted[i+1:][::-1]
    return ''.join(map(str, number_splitted))

result = input.copy()
result["Answer Expected"] = result["Number"].map(find_greater_from_same_digits)
print(pd.concat([result, test], axis=1))
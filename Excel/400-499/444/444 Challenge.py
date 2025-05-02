import pandas as pd

input = pd.read_excel("443 Look and Say Sequence.xlsx", usecols="A", nrows=10)
test = pd.read_excel("443 Look and Say Sequence.xlsx", usecols="B", nrows=10)

def generate_next(number):
    number_str = str(number)
    digits = []
    
    for digit in number_str:
        if digit not in digits:
            digits.append(digit)
    
    result = ""
    for digit in digits:
        count = number_str.count(digit)
        result += str(count) + digit
    
    return int(result)

def generate_sequence(start_digit, iter=4):
    result = [start_digit]
    
    for i in range(iter):
        next_number = generate_next(result[-1])
        result.append(next_number)
    
    all_numbers = [str(num) for num in result if num != start_digit]
    return ", ".join(all_numbers)

result = input.copy()
result["Answer Expected"] = result["Numbers"].map(lambda x: generate_sequence(x))

print(result["Answer Expected"].equals(test["Answer Expected"])) # True
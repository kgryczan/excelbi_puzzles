import pandas as pd
import itertools

# Reading the Excel file
test = pd.read_excel("419 Reverse Divisible & Not Palindromes.xlsx", usecols="A", nrows=12)

bases = ["1089", "2178"]

def insert9(num_char, max_length=8):
    fp, sp = num_char[:2], num_char[2:]
    sequence_of_nines = [f"{fp}{'9'*i}{sp}" for i in range(max_length + 1)]
    return sequence_of_nines

i9_1 = insert9(bases[0], 8)
i9_2 = insert9(bases[1], 8)

def insert0(num_char, max_length=8):
    sequence_of_zeroes = [f"{num_char}{'0'*i}{num_char}" for i in range(max_length + 1)]
    return sequence_of_zeroes

i0_1 = insert0(bases[0], 8)
i0_2 = insert0(bases[1], 8)

generated_numbers = list(itertools.chain(i9_1, i9_2, i0_1, i0_2))
generated_numbers = sorted([int(num) for num in generated_numbers])[:11]

expected_answer = test["Expected Answer"].tolist()
print(expected_answer == generated_numbers) # True
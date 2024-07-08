import pandas as pd
import math

path = "494 Tech Numbers.xlsx"
test = pd.read_excel(path).values.flatten().tolist()

def generate_sequence(n):
    sequence = []
    i = 1
    while len(sequence) < n:
        if math.sqrt(i) == int(math.sqrt(i)):
            if len(str(i)) % 2 == 0:
                half = len(str(i)) // 2
                first_half = str(i)[:half]
                second_half = str(i)[half:]
                if int(first_half) + int(second_half) == math.sqrt(i):
                    sequence.append(i)
        i += 1
    return sequence

result = generate_sequence(10)
print(result == test) # True

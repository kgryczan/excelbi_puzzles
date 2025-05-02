import pandas as pd

test = pd.read_excel("466 Bouncy Numbers.xlsx", usecols="A")

def is_bouncy(n):
    n = str(n)
    increasing = True
    decreasing = True
    for i in range(len(n) - 1):
        if n[i] < n[i + 1]:
            decreasing = False
        if n[i] > n[i + 1]:
            increasing = False
    return not increasing and not decreasing

def bouncy_numbers(n):
    bouncy = []
    i = 1
    while len(bouncy) < n:
        if is_bouncy(i):
            bouncy.append(i)
        i += 1
    return bouncy

result = bouncy_numbers(10000)

print(test['Answer Expected'].tolist() == result) # True
import pandas as pd

path = "669 Tech Numbers.xlsx"
test = pd.read_excel(path, usecols="A", nrows=10).fillna("").to_numpy().flatten().tolist()

tech_numbers = []
n = 10
while len(tech_numbers) < 10:
    if len(str(n)) % 2 == 0:
        h1, h2 = int(str(n)[:len(str(n))//2]), int(str(n)[len(str(n))//2:])
        if (h1 + h2) ** 2 == n:
            tech_numbers.append(n)
    n += 1

print(tech_numbers == test)
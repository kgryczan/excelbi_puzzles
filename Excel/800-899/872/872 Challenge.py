import pandas as pd

path = "Excel/800-899/872/872 Make Alternate Vowel Uppercase.xlsx"
input = pd.read_excel(path, usecols="A", nrows=50)
test = pd.read_excel(path, usecols="B", nrows=50)

def alternate_vowel_uppercase(s):
    vowels = "aeiouAEIOU"
    count = 0
    res = []
    for c in s:
        if c in vowels:
            count += 1
            res.append(c.upper() if count % 2 == 0 else c)
        else:
            res.append(c)
    return "".join(res)

result = input.iloc[:, 0].apply(alternate_vowel_uppercase)

print(result.tolist() == test.iloc[:, 0].tolist())

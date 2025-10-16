import pandas as pd
import re

path = "800-899/827/827 Lorem Ipsum.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=2)
test = str(pd.read_excel(path, usecols="C", nrows=2).values[0][0])

words = re.sub(r"[^\w\s]", "", str(input.loc[0, 'Text'])).split()
chars = list(str(input.loc[0, 'Alphabets']))

out = []

for a in chars:
    i = next((idx for idx, w in enumerate(words) if a in w), None)
    if i is not None:
        out.append(words[i])
        words = words[i+1:]

result = " ".join(out)
print(result == test) #True
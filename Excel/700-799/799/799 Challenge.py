import pandas as pd
import re

path = "700-799/799/799 Remove Characters between 2 Asterisks.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10)

def strip_star_pairs(x):
    while True:
        m = re.search(r"\*[^*]*\*", x)
        if not m: break
        inner = re.sub(r"[A-Za-z]+", "", x[m.start()+1:m.end()-1])
        x = x[:m.start()] + inner + x[m.end():]
    return x.replace("*", "")

input['answer'] = input.iloc[:, 0].apply(strip_star_pairs)

print(input['answer'].equals(test['Answer Expected'])) # True

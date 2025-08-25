import pandas as pd

path = "700-799/789/789 Fill in Missing Alphabets.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10)

def fill(s):
    return s[:1] + ''.join(
        b if a==b else ''.join(
            chr(c) for c in range(ord(a)+(1 if a<b else -1),
                                  ord(b)+(1 if a<b else -1),
                                  1 if a<b else -1)
        )
        for a,b in zip(s, s[1:])
    )

input['Expected Answer'] = input['Words'].apply(fill)

print(input['Expected Answer'].equals(test['Expected Answer'])) # True
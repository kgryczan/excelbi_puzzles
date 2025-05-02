import pandas as pd

input = pd.read_excel("460 Insert Dash Splitter.xlsx", usecols="A:B", nrows = 9)
test  = pd.read_excel("460 Insert Dash Splitter.xlsx", usecols="C", nrows = 9)

def split_by_dash(word, n):
    chars = list(word)
    chars.reverse()
    chunks = [chars[i:i+n] for i in range(0, len(chars), n)]
    reversed_chunks = ["".join(chunk[::-1]) for chunk in chunks]
    reversed_chunks.reverse()
    return "-".join(reversed_chunks)

input["Answer Expected"] = input.apply(lambda x: split_by_dash(x[0], x[1]), axis=1)

print(input["Answer Expected"].equals(test["Answer Expected"])) # True
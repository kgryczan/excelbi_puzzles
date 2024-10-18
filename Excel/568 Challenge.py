import pandas as pd
from itertools import chain

path = "568 Fill in the Alphabets.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10)

def fill_words(string):
    result = []
    def fill_sequence(first, second):
        if first < second:
            return [chr(n) for n in range(ord(first), ord(second))]
        elif first > second:
            return [chr(n) for n in range(ord(first), ord(second), -1)]
        return [first]

    result.extend(chain.from_iterable(fill_sequence(string[i], string[i + 1]) for i in range(len(string) - 1)))
    result.append(string[-1])
    return "".join(result)

input['Answer Expected'] = input.iloc[:, 0].apply(fill_words)
result = input.drop(columns=input.columns[0])

print(result.equals(test))  # True

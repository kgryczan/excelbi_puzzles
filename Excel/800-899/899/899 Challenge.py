import pandas as pd
import re

path = "Excel/800-899/899/899 Sorting Sentences by Number.xlsx"
input = pd.read_excel(path, usecols=[0], nrows=11)
test = pd.read_excel(path, usecols=[1], nrows=11)

def reorder_by_digits(text):
    words = text.split()
    words.sort(key=lambda x: (re.search(r'\d+', x) is None, int(re.search(r'\d+', x).group()) if re.search(r'\d+', x) else 0))
    words = [re.sub(r'\d+', '', word) for word in words]
    return ' '.join(words)

input['reordered'] = input['Input Sentence'].apply(reorder_by_digits)

result = input['reordered'].tolist() == test['Answer Expected'].tolist()
print(result)  # True
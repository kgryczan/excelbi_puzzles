import pandas as pd
import re

path = "594 Capitalize at Same Indexes.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10)

def capitalize_at_indexes(sentence):
    pos = [m.start() for m in re.finditer(r'[A-Z]', sentence)]
    answer = list(re.sub(r'[^a-zA-Z]', '', sentence).lower())
    answer = [char.upper() if i in pos else char for i, char in enumerate(answer)]
    return ''.join(answer)

input['answer'] = input['Sentences'].apply(capitalize_at_indexes)

print(input['answer'].equals(test['Answer Expected'])) # True

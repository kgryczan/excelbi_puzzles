import pandas as pd

path = "700-799/756/756 Replace Vowels.xlsx"
input = pd.read_excel(path, usecols="A", nrows=9)
test = pd.read_excel(path, usecols="B", nrows=9)

def process_word(word):
    vowels = 'aeiou'
    word = str(word)
    count = 0
    result = []
    for c in word:
        if c in vowels:
            count += 1
            result.append(f"{c}{count}")
        else:
            result.append(c)
    return ''.join(result)

input['Answer Expected'] = input.iloc[:,0].apply(process_word)
result = input.rename(columns={input.columns[0]: 'Words'})[['Words', 'Answer Expected']]

print(result['Answer Expected'].equals(test['Answer Expected'])) # True

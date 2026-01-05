import pandas as pd

path = "Excel/800-899/884/884 Scoring.xlsx"
input = pd.read_excel(path, usecols="A", nrows=51)
test = pd.read_excel(path, usecols="B", nrows=51)

def score(text):
    result, count = [], 1
    for i in range(1, len(text)):
        count = count + 1 if text[i] == text[i - 1] else result.append(text[i - 1] * count) or 1
    result.append(text[-1] * count)
    df = pd.DataFrame({'Result': result})
    df['Score'] = df['Result'].astype(str).str.len().apply(lambda l: 0 if l == 1 else 10 ** (l - 2))
    df['Score'] *= df.index.to_series().apply(lambda i: 2 if i == len(df) - 1 else 1)
    return df['Score'].sum()

result = input['Text Numbers'].apply(score)
print(result.equals(test['Score'])) # True
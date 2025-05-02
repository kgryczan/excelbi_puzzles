import pandas as pd

input = pd.read_excel("442 Columnar Transposition Cipher.xlsx",  usecols="A:B", nrows=10)
test = pd.read_excel("442 Columnar Transposition Cipher.xlsx",  usecols="C", nrows=10)

def encode(text, keyword):
    keyword = [c for c in keyword]
    keyword_sorted = sorted(keyword)
    keyword_rank = [sorted(keyword_sorted).index(c) + 1 for c in keyword] 
    for i in range(len(keyword)):
        if keyword.count(keyword[i]) > 1:
            keyword_rank[i] = keyword_sorted.index(keyword[i]) + 1
            keyword_sorted[keyword_sorted.index(keyword[i])] = None
    l_key = len(keyword)
    text = ''.join([c.lower() for c in text if c.isalpha()])
    text_filled = text + " " * (l_key - len(text) % l_key)    
    matrix_text = [text_filled[i:i+l_key] for i in range(0, len(text_filled), l_key)]
    matrix_text = [list(row) for row in zip(*matrix_text)]
    matrix_text = [row for _, row in sorted(zip(keyword_rank, matrix_text))]
    matrix_text = [[c for c in row if c != ' '] for row in matrix_text]
    matrix_text = [''.join(row) for row in matrix_text]
    matrix_text = ' '.join(matrix_text)
    
    return matrix_text

result = input.copy()
result['Answer Expected'] = result.apply(lambda row: encode(row['Plain Text'], row['Keyword']), axis=1)

print(result['Answer Expected'].equals(test['Answer Expected'])) # True
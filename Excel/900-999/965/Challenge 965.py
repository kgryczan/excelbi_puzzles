import pandas as pd
import re

path = "900-999/965/965 Find Words in Rows in a Grid.xlsx"
input_df = pd.read_excel(path, usecols="A:H", nrows=9, header=None)
words_df = pd.read_excel(path, usecols="J", nrows=5)
test_df = pd.read_excel(path, usecols="K", nrows=5)  

cols = list("ABCDEFGHIJKLMNOPQRSTUVWXYZ")[:input_df.shape[1]]
rows = list(range(1, input_df.shape[0] + 1))
grid_str = input_df.fillna("").astype(str).agg("".join, axis=1).tolist()

def find_word(w):
    matches = []
    n = len(w)
    w = str(w).strip()
    
    for i, row in enumerate(grid_str):
        for m in re.finditer(f'(?={w})', row):
            j = m.start()
            matches.append(f"{cols[j]}{rows[i]}:{cols[j+n-1]}{rows[i]}")
    
    return ", ".join(sorted(matches)) if matches else "Not Found"

result = (
    words_df.assign(Locations=words_df.iloc[:, 0].map(find_word))
)

print(result['Locations'].equals(test_df['Answer Expected']))
# True

import pandas as pd

path = "700-799/716/716 Key Cipher.xlsx"
input_df = pd.read_excel(path, usecols="A:B", nrows=10)
test_df = pd.read_excel(path, usecols="C", nrows=10)

input_df['encrypted'] = [
    ''.join(chr(ord(c) + int(k)) for c, k in zip(word, str(key) * len(word)))
    for word, key in zip(input_df['Words'], input_df['Key'])
]

result = input_df['encrypted'].tolist() == test_df.iloc[:, 0].tolist()
print(result)
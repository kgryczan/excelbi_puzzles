import pandas as pd

path = "Excel/900-999/920/920 Descendant Palindrome.xlsx"
input = pd.read_excel(path, usecols=[0], nrows=9)
test = pd.read_excel(path, usecols=[1], nrows=9, dtype=str).fillna("None")

def split_step(word):
    digits = [int(d) for d in str(word)]
    out = []
    for num in (digits[i] + digits[i+1] for i in range(len(digits) - 1)):
        if num >= 10:
            out.extend(map(int, str(num)))
        else:
            out.append(num)
    return "".join(map(str, out))

def split_and_process(word, max_iter=5000, max_len=20000):
    out = str(word)
    seen = set()

    for _ in range(max_iter):
        if len(out) >= 2 and out == out[::-1]:
            return out
        if out in seen or len(out) > max_len:
            return "None"
        seen.add(out)
        out = split_step(out)
        if len(out) < 2:
            return "None"

    return "None"

result = input['Number'].apply(split_and_process)
print(result.equals(test['Palindrome']))
# [1] True
import pandas as pd

path = "700-799/719/719 Parentheses Matching.xlsx"
input_df = pd.read_excel(path, usecols="A", nrows=10)
test_df = pd.read_excel(path, usecols="B", nrows=6)

def balance(s):
    stack = []
    openers = {'(': ')', '{': '}', '[': ']'}
    for ch in s:
        if ch in openers:
            stack.append(openers[ch])
        elif ch in openers.values():
            if not stack or stack[-1] != ch:
                return False
            stack.pop()
    return not stack

result = input_df[input_df['Brackets'].apply(balance)]

print(result)
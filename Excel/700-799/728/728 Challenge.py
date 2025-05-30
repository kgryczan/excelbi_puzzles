import pandas as pd

path = "700-799/728/728 Align Names.xlsx"
input_df = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=10)
test_df = pd.read_excel(path, usecols="D:E", skiprows=1, nrows=5)

used = set()
results = {}

def first_word(s):
    return str(s).split()[0] if pd.notnull(s) else ""

def last_word(s):
    return str(s).split()[-1] if pd.notnull(s) else ""

for n1 in input_df['Name 1']:
    first = first_word(n1)
    last = last_word(n1)
    matches = [
        n2 for n2 in input_df['Name 2']
        if n2 not in used and (first_word(n2) == first or last_word(n2) == last)
    ]
    if matches:
        used.update(matches)
        results[n1] = ", ".join(sorted(map(str, matches)))

result = pd.DataFrame({
    "name_1": list(results.keys()),
    "name_2": list(results.values())
})
print(result)
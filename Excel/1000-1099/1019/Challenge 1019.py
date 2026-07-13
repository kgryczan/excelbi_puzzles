import pandas as pd

path = "1000-1099/1019/1019 Painated Text.xlsx"
input = pd.read_excel(path, usecols="A", nrows=23, skiprows=1)
test = pd.read_excel(path, usecols="C:E", nrows=11, skiprows=1)

lines = []

for word in input["Word"]:
    candidate = f"{lines[-1]} {word}" if lines else word

    if lines and len(candidate) <= 15:
        lines[-1] = candidate
    else:
        lines.append(word)

result = pd.DataFrame(
    {
        "PageNumber": [i // 3 + 1 for i in range(len(lines))],
        "LineNumber": [i % 3 + 1 for i in range(len(lines))],
        "LineText": lines,
    }
)

print(result.equals(test))
# True

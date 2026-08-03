import pandas as pd

p = "1000-1099/1034/1034 Directional Pattern Replacement.xlsx"
data = pd.read_excel(p, nrows=16)


def replace_pattern(source, direction, pattern, replacement):
    positions = iter(
        range(len(source)) if direction == "F" else range(len(source) - 1, -1, -1)
    )
    positions = [
        next((i for i in positions if token == "*" or source[i] == token), None)
        for token in pattern
    ]
    if any(i is None for i in positions):
        return source

    result = list(source)
    for position, replacement_char in zip(positions, str(replacement)):
        result[position] = replacement_char
    return "".join(result)


data["Result"] = [
    replace_pattern(*row) for row in data.iloc[:, :4].itertuples(index=False, name=None)
]

print("Matches expected:", data.Result.eq(data["Answer Expected"]).all())

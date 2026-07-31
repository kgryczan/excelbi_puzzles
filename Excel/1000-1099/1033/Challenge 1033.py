import pandas as pd

p = "1000-1099/1033/1033 Extract Third Segment.xlsx"
data = pd.read_excel(p, usecols="A:B")


def third_segment(text):
    text = "" if pd.isna(text) else str(text)
    parts, start, depth = [], 0, 0
    for i, char in enumerate(text):
        depth += char == "<"
        depth -= char == ">"
        if char == "," and depth == 0 and text[i + 1 : i + 2] != " ":
            parts.append(text[start:i])
            start = i + 1
    parts.append(text[start:])
    return parts[2] if len(parts) > 2 else ""


result = data.assign(Result=data.Data.map(third_segment))[["Data", "Result"]]
print(result)
print(
    "Matches expected:", result.Result.fillna("").eq(data.iloc[:, 1].fillna("")).all()
)

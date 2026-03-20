import pandas as pd

path = "900-999/938/938 Extract As Per Depth.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=22)
test = pd.read_excel(path, usecols="C", nrows=22)


def extract_at_depth(signal: str, target: int) -> str | None:
    depth, result = 0, []
    for ch in signal:
        if ch == "(":
            depth += 1
        elif ch == ")":
            depth -= 1
        elif depth == target:
            result.append(ch)
    return "".join(result) or None


result = pd.DataFrame({
    "Answer Expected": input.apply(
        lambda row: extract_at_depth(str(row["Signal"]), int(row["Target Depth"])),
        axis=1,
    )
})

print(result.equals(test))
# True

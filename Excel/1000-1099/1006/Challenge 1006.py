import re
from functools import lru_cache
import pandas as pd

path = "1000-1099/1006/1006 Max Number Following a Pattern.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=12)
test = pd.read_excel(path, usecols="D", nrows=12)


@lru_cache(maxsize=None)
def _compiled_rule(rule: str) -> re.Pattern[str]:
    pattern, *rest = rule.split("/", 1)
    exclude = rest[0] if rest else ""
    pattern = pattern.translate(
        str.maketrans(
            {
                "E": "[02468]",
                "O": "[13579]",
                "X": "[0-9]",
            }
        )
    )
    if exclude:
        pattern = rf"^(?!.*[{re.escape(exclude)}]){pattern}$"
    else:
        pattern = rf"^{pattern}$"
    return re.compile(pattern)


def max_by_rule(rule: str, start: int, end: int) -> int | None:
    rx = _compiled_rule(rule)
    for value in range(end, start - 1, -1):
        if rx.fullmatch(str(value)):
            return value
    return None


input["result"] = [
    max_by_rule(rule, start, end)
    for rule, start, end in zip(input["Rule"], input["Start"], input["End"])
]

print(input["result"].equals(test["Answer Expected"]))
# True

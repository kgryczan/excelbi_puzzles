import pandas as pd
import re

path = "300-399/315/315 Letters Removal.xlsx"
input_df = pd.read_excel(path, usecols="A:B", nrows=9)
test = pd.read_excel(path, usecols="C", nrows=9)

planet_letters = "".join(
    sorted(set("".join(input_df["Planets"].dropna()).lower()))
)
pattern = re.compile(f"[{planet_letters}]", re.IGNORECASE)

result = (
    input_df["Author"]
    .apply(lambda s: re.sub(r"\s+", " ", pattern.sub("", s)).strip() or None)
    .rename("Answer Expected")
    .to_frame()
    .reset_index(drop=True)
)

print(result.equals(test))
# True

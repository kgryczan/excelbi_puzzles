import pandas as pd

path = "1000-1099/1008/1008 Data Extraction.xlsx"
input = pd.read_excel(path, usecols="A", nrows=11, skiprows=1)
test = pd.read_excel(path, usecols="B:D", nrows=11, skiprows=1)

domain_pattern = r"(?<=@)([A-Za-z0-9.-]+\.[A-Za-z]{2,})"
hex_pattern = r"(#[0-9A-Fa-f]{6})"
amount_pattern = r"((?:\$\s*\d+(?:[.,-]\d+)?|USD\s*\d+(?:[.,-]\d+)?|\d+(?:[.,-]\d+)?\s*USD|\d+(?:[.,-]\d+)?\s*\$))"


def parse_number_like(value):
    if pd.isna(value):
        return pd.NA
    text = str(value)
    match = pd.Series([text]).str.extract(r"(\d+(?:[.,-]\d+)?)", expand=False).iloc[0]
    if pd.isna(match):
        return pd.NA
    return pd.to_numeric(match.replace(",", "").replace("-", ""), errors="coerce")


result = (
    input.assign(
        email_domain=input["Data"]
        .astype(str)
        .str.extract(domain_pattern, expand=False),
        hex=input["Data"].astype(str).str.extract(hex_pattern, expand=False),
        amount=input["Data"]
        .astype(str)
        .str.extract(amount_pattern, expand=False)
        .map(parse_number_like),
    )
    .loc[:, ["hex", "email_domain", "amount"]]
    .rename(columns={"hex": "Hex_Code", "email_domain": "Domain", "amount": "Amount"})
)

print(result.equals(test))
# True

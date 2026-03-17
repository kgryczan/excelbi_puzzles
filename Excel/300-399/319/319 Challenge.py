import pandas as pd

path = "300-399/319/319 Powerful Numbers.xlsx"
input_df = pd.read_excel(path, usecols="A", nrows=9)
test     = pd.read_excel(path, usecols="B", nrows=5)


def is_powerful(n):
    if n == 1:
        return True
    d = 2
    while d * d <= n:
        if n % d == 0:
            exp = 0
            while n % d == 0:
                exp += 1
                n //= d
            if exp < 2:
                return False
        d += 1
    return n == 1  # no leftover prime factor


result = (
    input_df[input_df["Numbers"].apply(is_powerful)]
    .rename(columns={"Numbers": "Answer Expected"})
    .reset_index(drop=True)
)

print(result.equals(test))
# True

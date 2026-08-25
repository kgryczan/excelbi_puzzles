import pandas as pd

path = "1000-1099/1050/1050 Sum Digits in a Column.xlsx  "
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=10)
test = pd.read_excel(path, usecols="D:F", skiprows=1, nrows=30)


def digit_steps(n):
    while True:
        yield n

        if n < 10:
            return

        digits = str(n)
        if n % 2 == 0:
            digits = digits[::-1]

        n = sum(map(int, digits))


result = pd.DataFrame(
    [
        (id_, step, value)
        for id_, n in input.itertuples(index=False)
        for step, value in enumerate(digit_steps(n))
    ],
    columns=["ID", "Step", "Value"],
)

test.columns = result.columns
print(result.equals(test))
# True

import pandas as pd

path = "Excel\\900-999\\901\\901 First 10 Odd Numbers.xlsx"
test = pd.read_excel(path, usecols='A', nrows = 101)

res = []
n = 101

while len(res) < 100:
    if n % 2:
        s = str(n)
        f, l = int(s[0]), int(s[-1])

        if f != l and f != 0 and l != 0 and s[0] + s[-1] != "01":
            a = int(s[0] + s[-1])
            b = int(s[-1] + s[0])

            if n % a == 0 and n % b == 0:
                res.append(n)
    n += 2

print(res == test['Answer Expected'].tolist()) # True
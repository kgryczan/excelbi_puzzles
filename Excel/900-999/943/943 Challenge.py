import pandas as pd

path = "900-999/943/943 Next 3 Distinct Digit Numbers.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B:D", nrows=10)

def get_distinct_digits(n: int) -> int:
    x = int(n) + 1
    while len(set(str(x))) != len(str(x)):
        x += 1
    return x

def next3(n: int) -> list:
    results = []
    x = int(n)
    for _ in range(3):
        x = get_distinct_digits(x)
        results.append(x)
    return results

nums = input.iloc[:, 0].dropna().astype(int)
res = pd.DataFrame([next3(n) for n in nums], columns=["next3_1", "next3_2", "next3_3"]) 
test = test.dropna(how="all").reset_index(drop=True)
res = res.reset_index(drop=True)
test.columns = res.columns

print((res == test).all().all())
# True
import pandas as pd

path = "300-399/316/316 Even Fibonacci Numbers.xlsx"
test = pd.read_excel(path, usecols="A", nrows=20)


def even_fibonacci(n):
    result = []
    a, b = 0, 1
    while len(result) < n:
        if a % 2 == 0:
            result.append(a)
        a, b = b, a + b
    return result


result = pd.DataFrame(
    {"First 20 Even Fibonnaci Numbers": even_fibonacci(20)}
)

print(result.equals(test))
# True

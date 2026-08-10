import pandas as pd

path = "1000-1099/1039/1039 Asteroids Collision.xlsx"
input = pd.read_excel(path, usecols="A", dtype=str)
test = pd.read_excel(path, usecols="B", dtype=str)


def survive(values):
    stack = []
    for asteroid in map(int, values.split(",")):
        while stack and stack[-1] > 0 > asteroid:
            if abs(stack[-1]) < abs(asteroid):
                stack.pop()
                continue
            if abs(stack[-1]) == abs(asteroid):
                stack.pop()
            break
        else:
            stack.append(asteroid)
    return ",".join(map(str, stack))


result = input.Asteroids.map(survive)
print(result.equals(test["Answer Expected"]))
# One entry incorrect in test.

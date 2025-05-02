import pandas as pd

input = pd.read_excel("472 Operator in a grid.xlsx", usecols="A:G", nrows = 9)
test = pd.read_excel("472 Operator in a grid.xlsx", usecols="I", nrows = 9)

pattern = r'^(\d+)(\D+)(\d+)$'

def evaluate_expression(n1, op, n2):
    n1 = float(n1)
    n2 = float(n2)
    if op == "+":
        return n1 + n2
    elif op == "-":
        return n1 - n2
    elif op == "*":
        return n1 * n2
    elif op == "/":
        return n1 / n2

input = input.astype(str)
result = input.apply(lambda row: "".join(row), axis=1)
result = result.str.extract(pattern)
result.columns = ["n1", "op", "n2"]
result["Answer Expected"] = result.apply(lambda row: evaluate_expression(row["n1"], row["op"], row["n2"]), axis=1)

print(result["Answer Expected"].equals(test["Answer Expected"])) # True
import operator as op
import pandas as pd

path = "700-799/764/764 Reverse Polish Notation_2.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10)

def eval_rpn(tokens):
    stack = []
    for t in tokens:
        if t in '+-*/':
            if len(stack) > 2:
                res = stack[0]
                for n in stack[1:]:
                    res = eval(f"{res}{t}{n}")
                stack = [res]
            else:
                b = stack.pop()
                a = stack.pop()
                stack.append(eval(f"{a}{t}{b}"))
        else:
            stack.append(int(t))
    return stack[0]

input['Result'] = input['Text'].apply(lambda x: eval_rpn(x.split(", "))).astype(int)

print(input["Result"].equals(test["Expected Answer"])) # True

import pandas as pd

path = "900-999/976/976 LIFO Stack.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=26, skiprows=0)
test = pd.read_excel(path, usecols="C", nrows=26, skiprows=0).dropna().reset_index(drop=True)

commands = input.iloc[:, 0].astype(str).str.strip().str.lower()
values = pd.to_numeric(input.iloc[:, 1], errors="coerce")

stack = []
max_stack = []
max_outputs = []

for cmd, v in zip(commands, values):
	if cmd == "push" and pd.notna(v):
		new_max = v if not max_stack else max(v, max_stack[-1])
		stack.append(v)
		max_stack.append(new_max)
	elif cmd == "pop" and stack:
		stack.pop()
		max_stack.pop()
	elif cmd == "max":
		max_outputs.append(max_stack[-1] if max_stack else float("nan"))

max_outputs = pd.Series(max_outputs)

print(max_outputs.equals(test['Answer Expected']))
# True
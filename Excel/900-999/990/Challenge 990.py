import pandas as pd

path = "900-999/990/990 Final String After Edits.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=31, skiprows=1)
test = pd.read_excel(path, usecols="D:E", nrows=5, skiprows=1).rename(columns=lambda c: c.replace(".1", "") if isinstance(c, str) else c)

cmds = {
    "APPEND": lambda stack, arg: stack + [arg],
    "DUP": lambda stack, arg: stack + stack,
    "REVERSE": lambda stack, arg: stack[::-1],
    "DROP": lambda stack, arg: stack[:-1],
}
def run(commands):
    stack = []
    for command in commands:
        cmd, *arg = command.split(":", 1)
        stack = cmds[cmd](stack, arg[0] if arg else None)
    return stack
result = (
    input
    .groupby("Session")["Command"]
    .apply(run)
    .apply("".join)
    .reset_index(name="FinalText")
)
print(result.equals(test))
# True

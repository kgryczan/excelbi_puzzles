import pandas as pd

input = pd.read_excel("300-399/377/PQ_Challenge_377.xlsx", usecols="A:D", nrows=21)
test = pd.read_excel("300-399/377/PQ_Challenge_377.xlsx", usecols="G:I", nrows=2)

class Robot:
    def __init__(self, start):
        self.x, self.y = map(int, start.split(","))

    def move(self, action, value):
        if action == "MoveUp": self.y += value
        elif action == "MoveDown": self.y -= value
        elif action == "MoveRight": self.x += value
        elif action == "MoveLeft": self.x -= value

def solve(group):
    r = Robot(group.loc[group.Action=="Start","Value"].iloc[0])
    for a, v in zip(group.Action, group.Value):
        if a != "Start":
            r.move(a, int(v))
    return pd.Series({"Final_X": r.x, "Final_Y": r.y})

result = input.groupby("Robot").apply(solve)

print((result['Final_X'].values == test['Final X'].values).all()) # True
print((result['Final_Y'].values == test['Final Y'].values).all()) # True
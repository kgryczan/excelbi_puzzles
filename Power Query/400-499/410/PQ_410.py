import pandas as pd

path = "400-499/410/PQ_Challenge_410.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=20)
test = pd.read_excel(path, usecols="F:I", nrows=20, keep_default_na=False)
test.columns = ["Group", "EliminationOrder", "PersonID", "PersonName"]

rows = []
for group, data in input.groupby("Group", sort=False):
    alive = list(data.PersonID)
    names = dict(zip(data.PersonID, data.PersonName))
    step_size = int(data.StepSize.iloc[0])
    index = 0

    for order in range(1, len(alive) + 1):
        index = (index + step_size - 1) % len(alive)
        person_id = alive.pop(index)
        rows.append([group, order, person_id, names[person_id]])

result = pd.DataFrame(
    rows, columns=["Group", "EliminationOrder", "PersonID", "PersonName"]
)
print(result.equals(test))

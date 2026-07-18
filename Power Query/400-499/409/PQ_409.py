import pandas as pd

path = "400-499/409/PQ_Challenge_409.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=20)
test = pd.read_excel(path, usecols="E:H", nrows=81, keep_default_na=False)
test.columns = ["ID", "Step", "Out1", "Out2"]
test[["Out1", "Out2"]] = test[["Out1", "Out2"]].astype(str)

rows = []
for _, r in input.iterrows():
    a, b = r.Data1.split(","), r.Data2.split(",")
    prev = ("N/A", "N/A")

    for step, (x, y) in enumerate(zip(a, b), 1):
        pair = (
            prev
            if not x and not y
            else (y, y) if not x else (x, x) if not y else (x, y)
        )
        rows.append([r.ID, step, *pair])
        prev = pair

result = pd.DataFrame(rows, columns=["ID", "Step", "Out1", "Out2"])
print(result.equals(test))

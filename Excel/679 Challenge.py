import pandas as pd

path = "679 Last Item to be Selected.xlsx"
input = pd.read_excel(path, usecols="A:D", skiprows=1, nrows=18)
test = pd.read_excel(path,  usecols="F:G", skiprows=1, nrows=4)

df = input.fillna('')

def last_item(data):
    N = int(data[0])
    items = [i for i in data[1:] if i]
    front = True

    while len(items) > N:
        if front:
            items = items[N:]
        else:
            items = items[:-N]
        front = not front

    return items[-1]

result = pd.DataFrame({
    'Run': df.columns,
    'Last Item': [last_item(df[column].tolist()) for column in df.columns]
})

print(result.equals(test)) # True
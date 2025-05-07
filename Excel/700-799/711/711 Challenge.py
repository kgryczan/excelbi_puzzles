import pandas as pd

path = "700-799/711/711 Generate a Sequence.xlsx"

input = pd.read_excel(path, usecols="A", nrows=6)
test = pd.read_excel(path, usecols="A:K", nrows=6)

def extract_sequence(start_num):
    sequence, pad_and_extract = [start_num], lambda n: int(f"{n**2:08d}"[2:6])
    while (next_val := pad_and_extract(sequence[-1])) not in sequence:
        sequence.append(next_val)
    return sequence

result = (
    input
    .assign(seq=input.iloc[:, 0].map(lambda x: extract_sequence(x)))
    .explode('seq')
    .groupby(input.columns[0])
    .apply(lambda group: group.iloc[1:])
    .reset_index(drop=True)
    .query("seq != 0")
    .assign(rn=lambda df: df.groupby(input.columns[0]).cumcount() + 1)
    .query("rn <= 10")
    .pivot(index=input.columns[0], columns='rn', values='seq')
    .reset_index()
)

print(result)
import pandas as pd

path = "PQ_Challenge_255.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=14)
test = pd.read_excel(path, usecols="E:J", nrows=3)

input = input.pivot(index='Ticket', columns='Task', values='Date Time')

for col in range(2, 7):
    input[f'{col}-1'] = input.apply(
        lambda row: round((row[col] - row[1]).total_seconds() / 3600, 2) if pd.notna(row[col]) else None, axis=1
    )

input.drop(columns=range(1, 7), inplace=True)
input.reset_index(inplace=True)
input.rename(columns={'Ticket': 'Task.1'}, inplace=True)

print(input.equals(test)) # True
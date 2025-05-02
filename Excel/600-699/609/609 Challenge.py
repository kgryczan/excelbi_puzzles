import pandas as pd
import numpy as np

path = "609 Missing Terms in AP_3.xlsx"
input = pd.read_excel(path, usecols="A:J", nrows=10).apply(pd.to_numeric, errors='coerce')
test = pd.read_excel(path, usecols="A:J", skiprows=12, nrows=10).astype(np.float64)

input['LastPopulatedColumn'] = input.apply(lambda row: row.last_valid_index(), axis=1)
input['LastPopulatedValue'] = input.apply(lambda row: row[row['LastPopulatedColumn']], axis=1)
input['FirstValue'] = input.apply(lambda row: row['Term1'], axis=1)
input['Length'] = input['LastPopulatedColumn'].apply(lambda x: int(''.join(filter(str.isdigit, x))))

def generate_sequence(row):
    step = (row['LastPopulatedValue'] - row['FirstValue']) / (row['Length'] - 1)
    return [row['FirstValue'] + i * step for i in range(row['Length'])]

input['Sequence'] = input.apply(generate_sequence, axis=1)

sequence_df = pd.DataFrame(input['Sequence'].tolist(), columns=[f'Term{i+1}' for i in range(input['Length'].max())]).astype(np.float64)

print(sequence_df.equals(test)) # True
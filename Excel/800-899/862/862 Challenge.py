import pandas as pd

def read_excel_sequence(path):
    df = pd.read_excel(path, usecols="H:AX", nrows=65)
    values = df.to_numpy().flatten()
    sequence = pd.Series(values).dropna().astype(int).to_list()
    return sequence

expected_sequence = read_excel_sequence("Excel\\800-899\\862\\862 Gijswijt's Sequence.xlsx")

def max_repeated_block_length(seq):
    max_length = 1
    for block_size in range(1, len(seq) + 1):
        count, block, max_possible = 1, seq[-block_size:], len(seq) // block_size
        if max_possible <= max_length:
            return max_length
        while seq[-(count + 1) * block_size : -count * block_size] == block:
            count += 1
        max_length = max(max_length, count)

def build_sequence_until_four():
    sequence = [1]
    while True:
        next_number = max_repeated_block_length(sequence)
        sequence.append(next_number)
        if next_number == 4:
            break
    return sequence

result_sequence = build_sequence_until_four()
print(result_sequence == expected_sequence)


import pandas as pd

path = "700-799/761/761 Open POs.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=11)
test = pd.read_excel(path, usecols="D", nrows=6)

def expand_sequence(notation):
    parts = notation.split('-')
    return list(range(int(parts[0]), int(parts[-1]) + 1)) if len(parts) > 1 else [int(parts[0])]

def reverse_expand_sequence(seq):
    return str(seq[0]) if len(seq) == 1 else f"{seq[0]}-{seq[-1]}"


input['PO'] = input['PO'].astype(str).apply(expand_sequence)
input = input.explode('PO')
opens = input[input['Status'] == 'Open']
closed = input[input['Status'] == 'Closed']
opens_still = opens[~opens['PO'].isin(closed['PO'])]
opens_still['grp'] = (opens_still['PO'].diff().fillna(1) > 1).cumsum()
result = opens_still.groupby('grp')['PO'].apply(lambda x: reverse_expand_sequence(sorted(x))).reset_index(drop=True)

print(result.equals(test['Answer Expected']))

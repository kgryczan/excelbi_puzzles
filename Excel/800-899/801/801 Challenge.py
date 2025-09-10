import pandas as pd

path = "800-899/801/801 Name and Seq.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=6)
test = pd.read_excel(path, usecols="D:F", skiprows=1, nrows=19).rename(columns=lambda c: c.replace('.1', ''))

rows = []
for _, row in input.iterrows():
    for data in str(row['Data']).split('; '):
        data = data.replace('\t', ' ')
        parts = data.split(' : ')
        name = parts[0]
        seqs = parts[1] if len(parts) > 1 else ''
        for seq in seqs.split(', '):
            rows.append({'Name': name, 'Seq': pd.to_numeric(seq, errors='coerce'), 'State': row.get('State', None)})

result = pd.DataFrame(rows).dropna(subset=['Seq']).sort_values('Seq').reset_index(drop=True)
result['Seq'] = result['Seq'].astype('int64')

print(result.equals(test))
# True
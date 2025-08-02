import pandas as pd

# Read Excel file
path = "300-399/309/PQ_Challenge_309.xlsx"
input = pd.read_excel(path, usecols="A", nrows=20)
test = pd.read_excel(path, usecols="C:D", nrows=5)\
    .rename(columns=lambda x: x.replace('.1', ''))\
    .astype(str)

def group_consecutive_under_limit(x, limit=50):
    groups = []
    group_labels = []
    group = 1
    subtotal = 0
    for val in x:
        if subtotal + val > limit:
            group += 1
            subtotal = val
        else:
            subtotal += val
        groups.append(group)
        group_labels.append(f'Group{group}')
    return group_labels

input['Groups'] = group_consecutive_under_limit(input.iloc[:,0], 50)

result = (
    input
    .groupby('Groups', as_index=False)
    .agg({'Values': lambda x: ', '.join(map(str, x))})
)

print(result.equals(test)) # True

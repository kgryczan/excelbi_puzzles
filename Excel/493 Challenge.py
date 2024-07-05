import pandas as pd

path = "493 Start End Indexes for a Particular Sum.xlsx"

input = pd.read_excel(path, skiprows=1, usecols="A:B")
test = pd.read_excel(path, skiprows=1, usecols="D:F", nrows = 7)

def group_accumulate(numbers, max_sum=100):
    total = 0
    group = 0
    groups = []
    for number in numbers:
        if total + number > max_sum:
            group += 1
            total = number
        else:
            total += number
        groups.append(group)
    return groups

input['group'] = group_accumulate(input['Number'])

result = input.groupby('group').agg(
    Start_Index=('Index', 'min'),
    End_Index=('Index', 'max'),
    Sum=('Number', 'sum')
).reset_index(drop=True)

result = result[['Start_Index', 'End_Index', 'Sum']]

print(result)
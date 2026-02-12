import pandas as pd

path = "Excel/900-999/912/912 Overlapped DateTime.xlsx"
input = pd.read_excel(path, skiprows=1, usecols="A:C", nrows=14)
test = pd.read_excel(path, skiprows=1, usecols="E:G", nrows=5)

input['Int'] = list(zip(input['Start Datetime'], input['End Datetime']))

input = input.sort_values(by='Start Datetime').reset_index(drop=True)

def assign_groups(df):
    groups = []
    current_group = 1
    for i, row in df.iterrows():
        if i == 0:
            groups.append(current_group)
        else:
            prev_interval = df.loc[i - 1, 'Int']
            current_interval = row['Int']
            if prev_interval[1] < current_interval[0]:
                current_group += 1
            groups.append(current_group)
    return groups

input['Group'] = assign_groups(input)

grouped = input.groupby('Group').agg(
    Group_Start=('Start Datetime', 'first'),
    Group_End=('End Datetime', 'last'),
    ID=('ID', lambda x: ", ".join(map(str, x)))
).reset_index()

grouped = grouped[['ID', 'Group_Start', 'Group_End']]
grouped.columns = ['Group', 'Group Start', 'Group End']

print(grouped.equals(test))

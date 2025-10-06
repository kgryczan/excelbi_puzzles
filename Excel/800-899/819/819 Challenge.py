import pandas as pd

path = "800-899/819/819 Merging Shifts.xlsx"

input = pd.read_excel(path, usecols="A:D", skiprows=1, nrows=11)
test = pd.read_excel(path, usecols="F:H", skiprows=1, nrows=6).rename(columns=lambda x: x.replace('.1', ''))

input['Shift_Num'] = input['Shift'].str.extract(r'(\d+)').astype(int)
input = input.sort_values(['Emp No.', 'Shift_Num'])

input['group_id'] = (
    input.groupby('Emp No.').apply(
        lambda df: (df['Start Time'] != df['End Time'].shift()).cumsum()
    ).reset_index(level=0, drop=True)
)

input = input.groupby(['Emp No.', 'group_id']).agg({
    'Shift': 'first', 'Start Time': 'first', 'End Time': 'last'})
input = input.reset_index()
input = input.drop(columns=['group_id', 'Shift'])

print(input.equals(test)) # True
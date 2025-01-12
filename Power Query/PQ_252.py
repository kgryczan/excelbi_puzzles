import pandas as pd

path = "PQ_Challenge_252.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=17)
test = pd.read_excel(path, usecols="F:J", nrows=10).rename(columns=lambda x: x.split('.')[0])

def consecutive_id(condition):
    group = 0
    ids = []
    for cond in condition:
        if cond:
            group += 1
        ids.append(group)
    return ids


input['store_no_nchar'] = input['Store No'].str.len()==1
input['group'] = consecutive_id(input['store_no_nchar'])
input['group'] = (input['store_no_nchar'] != input['store_no_nchar'].shift()).cumsum()

odd_groups = input[input['group'] % 2 != 0]
odd_groups = pd.concat([odd_groups]).reset_index(drop=True)
odd_groups = odd_groups[['Store No', 'Store Name', 'group']]
odd_groups['group'] = odd_groups['group'] + 1

even_groups = input[input['group'] % 2 == 0]
even_groups = pd.concat([even_groups]).reset_index(drop=True)
even_groups.columns = even_groups.iloc[0]
even_groups = even_groups[1:].reset_index(drop=True)
even_groups = even_groups[['Customer', 'First Visit Date', 'Last Purchase Date',2]] 
even_groups = even_groups[even_groups['Customer'] != 'Customer']
even_groups = even_groups.rename(columns={2: 'group'})

merged_groups = pd.merge(odd_groups, even_groups, on='group', how='inner')
merged_groups = merged_groups.drop(columns=['group'])
merged_groups['First Visit Date'] = pd.to_datetime(merged_groups['First Visit Date'])
merged_groups['Last Purchase Date'] = pd.to_datetime(merged_groups['Last Purchase Date'])


print(merged_groups == type)

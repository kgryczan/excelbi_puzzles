import pandas as pd

path = "664 Remove Rejected Batches.xlsx"
input = pd.read_excel(path, usecols="A:D", skiprows=2, nrows=14)
test = pd.read_excel(path, usecols="F:H", skiprows=1, nrows=10).rename(columns=lambda x: x.split('.')[0]).apply(lambda x: x.sort_values().values)

input_list_of_lists = input.values.T.tolist()
input_list_of_lists = [[item for item in sublist if pd.notna(item)] for sublist in input_list_of_lists]
result = pd.DataFrame({"Round1": list(set(input_list_of_lists[0]) - set(input_list_of_lists[1]))})
result["Round2"] = pd.Series(list(set(input_list_of_lists[0]) - set(input_list_of_lists[1] + input_list_of_lists[2])))
result["Round3"] = pd.Series(list(set(input_list_of_lists[0]) - set(input_list_of_lists[1] + input_list_of_lists[2] + input_list_of_lists[3])))

for col in ["Round1", "Round2", "Round3"]:
    result[col] = result[col].sort_values().reset_index(drop=True)

print(result.equals(test)) # True
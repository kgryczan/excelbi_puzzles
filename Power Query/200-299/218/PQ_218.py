import pandas as pd

path = "PQ_Challenge_218.xlsx"
input = pd.read_excel(path, usecols="A:C")
test = pd.read_excel(path, usecols="E:G", nrows=4).rename(columns=lambda x: x.replace(".1", ""))

input["Status"] = input["Completion Date"].apply(lambda x: "Not Completed Tasks" if pd.isnull(x) else "Completed Tasks")
input = input.drop(columns="Completion Date").pivot_table(index="Project", columns="Status", aggfunc=lambda x: ', '.join(map(str, x)))
input.columns = input.columns.droplevel()
input = input.reset_index().rename_axis(None, axis=1)

print(input.equals(test)) # True
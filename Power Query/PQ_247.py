import pandas as pd

path = "PQ_Challenge_247.xlsx"
input1 = pd.read_excel(path, usecols="A:C", nrows=13)
input2 = pd.read_excel(path, usecols="A:B", skiprows=15, nrows=5)
test = pd.read_excel(path, usecols="E:J", nrows=3).rename(columns=lambda x: x.split('.')[0])

input = input1.merge(input2, on="Question", how="left")
input['correctness'] = (input['Option Chosen'] == input['Correct Option']).map({True: 'Y', False: 'N'})
input = input.drop(columns=['Option Chosen', 'Correct Option'])
input = input.pivot(index='Name', columns='Question', values='correctness').rename(columns=lambda x: f"Q{x}")
input['Score'] = (input == 'Y').sum(axis=1)
input.reset_index(inplace=True)

print(input.equals(test)) # True
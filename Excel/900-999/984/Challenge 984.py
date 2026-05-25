import pandas as pd

path = "900-999/984/984 Assigning Machine States.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=21, skiprows=0)
test = pd.read_excel(path, usecols="D", nrows=21, skiprows=0)

states = []
for i in range(len(input)):
    prev_state = 'Active' if i == 0 else states[-1]
    if i < 2:
        states.append(prev_state)
    else:
        last_three = input.iloc[i-2:i+1]['Result']
        if prev_state == 'Active':
            states.append('Halted' if (last_three == 'Fail').sum() >= 2 else 'Active')
        else:
            states.append('Active' if (last_three == 'Pass').sum() == 3 else 'Halted')
input['State'] = states

print(input['State'].equals(test['Answer Expected']))
# True
import pandas as pd
import re

path = "643 Shift Numbers by One Position.xlsx"
input = pd.read_excel(path, usecols="A", nrows=8)
test = pd.read_excel(path, usecols="B", nrows=8)

def shift_digits(s):
    split = re.split(r'(\d+|\D+)', s)
    split = [x for x in split if x]
    digit_idxs = [i for i, part in enumerate(split) if part.isdigit()]
    
    if digit_idxs:
        shifted_digits = [split[digit_idxs[-1]]] + [split[i] for i in digit_idxs[:-1]]
        for i, idx in enumerate(digit_idxs):
            split[idx] = shifted_digits[i]
    
    return ''.join(split)

input['answer'] = input.iloc[:, 0].apply(shift_digits)

print(input['answer'].equals(test['Answer Expected']))  #True

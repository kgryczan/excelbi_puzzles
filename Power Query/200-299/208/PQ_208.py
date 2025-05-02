import pandas as pd
import random

path = "PQ_Challenge_208.xlsx"
input = pd.read_excel(path, usecols="A:C")

def find_defects(input):
    def generate_integer_set_with_mean(target_mean):
        x1 = random.randint(1, 2 * target_mean)
        x2 = random.randint(1, 2 * target_mean)
        x3 = 3 * target_mean - x1 - x2
        
        while x3 <= 0 or x3 > 2 * target_mean:
            x1 = random.randint(1, 2 * target_mean)
            x2 = random.randint(1, 2 * target_mean)
            x3 = 3 * target_mean - x1 - x2
        
        return [x1, x2, x3]
    
    initial_set = generate_integer_set_with_mean(input['3 Year MV'].dropna().iloc[0])
    
    input['Defects'] = [initial_set[0], initial_set[1], initial_set[2]] + [None] * (len(input) - 3)

    for i in range(3, len(input) - 1):
        input['Defects'].iloc[i] = 3 * input['3 Year MV'].iloc[i+1] - sum(input['Defects'].iloc[i-3:i])

    return input

output = input.groupby('Month').apply(find_defects).reset_index(drop=True)

print(output)

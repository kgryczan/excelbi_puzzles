import pandas as pd
import numpy as np
import itertools

path = "502 Remove Minimum Digits to Make a Cube.xlsx"
input = pd.read_excel(path, usecols="A", skiprows= 1)
test = pd.read_excel(path, usecols="B:C", skiprows= 1)

def cube_number(number):
    str_nums = list(str(number))
    digits_combinations = ["".join(comb) for i in range(1, len(str_nums)) for comb in itertools.combinations(str_nums, i)]
    all_combinations = [comb for comb in digits_combinations if round(int(comb) ** (1/3)) ** 3 == int(comb)]
    
    if all_combinations:
        cube = max(all_combinations, key=int)
        digits_left = list(set(str_nums) - set(str(cube)))
        unique_digits = list(set(digits_left))
        return [unique_digits, int(cube)]
    else:
        return [np.NaN, np.NaN]

result = input.copy()
result["Output"] = result["Numbers"].apply(cube_number)
result[["Removed Digits", "Cube Number"]] = result["Output"].apply(lambda x: pd.Series([x[0], x[1]]))
result["Removed Digits"] = result["Removed Digits"].apply(lambda x: ", ".join(sorted(x)) if isinstance(x, list) else x)
result = result.drop(columns=["Numbers", "Output"]).reset_index(drop=True)

print(result.equals(test)) # True

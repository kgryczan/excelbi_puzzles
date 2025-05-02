import pandas as pd
import math
import itertools

path = "517 Arrange Numbers to Form Square Chains.xlsx"
input = pd.read_excel(path, usecols="A").values.flatten()
test = pd.read_excel(path, usecols="B").values.flatten()

def is_perfect_square(x):
    return math.isqrt(x)**2 == x

def is_valid_sequence(nums):
    return all(is_perfect_square(nums[i] + nums[i+1]) for i in range(len(nums) - 1))

def find_valid_permutation(nums):
    for perm in itertools.permutations(nums):
        if is_valid_sequence(perm):
            return list(perm)
    return None

result = find_valid_permutation(input)
result = " ".join(map(str, result[::-1]))
test = " ".join(map(str, test))

print(result == test)   # True
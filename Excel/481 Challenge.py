import pandas as pd
import itertools
import time

path = '481 Taxicab Numbers.xlsx'
input = pd.read_excel(path, usecols="A")
test  = pd.read_excel(path, usecols="B")

start_time = time.time()

def is_taxicab(num):
    croot = round(num**(1/3) + 0.5)
    seq = range(1, croot)
    comb = [x for x in itertools.combinations(seq, 2) if x[0]**3 + x[1]**3 == num]
    
    if len(comb) >= 2:
        return "Y"
    else:
        return "N"

result = input.copy()
result['Answer Expected'] = result['Numbers'].apply(is_taxicab)

end_time = time.time()
execution_time = end_time - start_time
print("Execution time:", execution_time, "seconds")
# Execution time: 0.012981891632080078 seconds

print(result['Answer Expected'].equals(test['Answer Expected'])) # True
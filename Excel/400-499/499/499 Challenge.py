import pandas as pd
import time

path = "499 Lynch Bell Numbers.xlsx"
test = pd.read_excel(path, usecols="A").values.flatten().tolist()

def check_lynchbell(n):
    s = str(n)
    if "0" in s or len(set(s)) < len(s) or n <= 10: return False
    return all(n%int(d) == 0 for d in s)

start_time = time.time()
numbers = [k for k in range(9876543) if check_lynchbell(k)][:500]
end_time = time.time()

execution_time = end_time - start_time

print("Execution time:", execution_time, "seconds") # Execution time: 3.345 seconds
print(test == numbers) # True
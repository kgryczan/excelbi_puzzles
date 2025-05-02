import math
from itertools import permutations
import time
import pandas as pd

test = pd.read_excel("447 Penholodigital Squares.xlsx", usecols = "A", nrows = 30)

start_time = time.time()
penholodigital_numbers = [
    num for num in (
        int(''.join(map(str, perm))) for perm in permutations('123456789')
    ) if int(math.sqrt(num)) ** 2 == num
]

end_time = time.time()
execution_time = end_time - start_time

# for validation purpose
penholodigital_numbers = pd.DataFrame(penholodigital_numbers, columns = ["Answer Expected"])

print(penholodigital_numbers.equals(test)) # True
print("Execution time:", execution_time, "seconds") # 0.2874 seconds
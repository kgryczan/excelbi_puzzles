from math import isqrt, sqrt
import time

def divisor_square_sum(n):
    factors = [i for i in range(1, n + 1) if n % i == 0]
    return sum(i**2 for i in factors)

def is_perfect_square(x):
    return isqrt(x)**2 == x

start_time = time.time()

result = [n for n in range(1, 50000) if is_perfect_square(divisor_square_sum(n))][:20]

end_time = time.time()
elapsed_time = end_time - start_time

print(f"Time taken: {elapsed_time} seconds")
print(result)
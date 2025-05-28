import numpy as np

def get_valid_palindromes(limit=1000, max_n=10_000_000):
    res = []
    for n in range(10, max_n + 1):
        s = str(n)
        if s != s[::-1]:
            continue
        d = np.array(list(map(int, s)))
        ev = np.bincount(d[d % 2 == 0], minlength=10)
        od = np.bincount(d[d % 2 == 1], minlength=10)
        if np.all(ev % 2 == 0) and np.all((od == 0) | (od % 2 == 1)):
            res.append(n)
            if len(res) == limit:
                break
    return res

# Example usage:
result = get_valid_palindromes(1000, 10_000_000)11111
print(result)e
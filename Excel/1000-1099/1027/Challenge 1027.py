import numpy as np

n = 6
lengths = [n - 1] + [x for x in range(n - 1, 0, -1) for _ in range(2)]
directions = np.array([[0, 1], [1, 0], [0, -1], [-1, 0]])

steps = directions[np.repeat(np.arange(len(lengths)) % 4, lengths)]
positions = np.vstack(([0, 0], steps)).cumsum(axis=0)

result = np.zeros((n, n), dtype=int)
result[positions[:, 0], positions[:, 1]] = np.arange(1, n**2 + 1)

print(result)

import pandas as pd
import numpy as np

path = "651 Vortex Sequence.xlsx"
test2 = pd.read_excel(path,  usecols="B:C", skiprows=1,  nrows = 2, header=None).to_numpy()
test4 = pd.read_excel(path,  usecols="B:E", skiprows = 5, nrows = 4, header=None).to_numpy()
test7 = pd.read_excel(path,  usecols="B:H", skiprows = 11, nrows = 7, header=None).to_numpy()

def spiral_matrix(n):
    matrix = np.zeros((n, n), dtype=int)
    directions = [(-1, 0), (0, 1), (1, 0), (0, -1)]
    dir_idx = 0
    pos = [n-1, 0] 
    
    for i in range(1, n * n + 1):
        matrix[pos[0], pos[1]] = i
        next_pos = [pos[0] + directions[dir_idx][0], pos[1] + directions[dir_idx][1]]
        
        if (not (0 <= next_pos[0] < n and 0 <= next_pos[1] < n) or 
            matrix[next_pos[0], next_pos[1]] != 0):
            dir_idx = (dir_idx + 1) % 4
            next_pos = [pos[0] + directions[dir_idx][0], pos[1] + directions[dir_idx][1]]
        pos = next_pos
    
    return matrix

print(np.array_equal(test2, spiral_matrix(2))) # True
print(np.array_equal(test4, spiral_matrix(4))) # True
print(np.array_equal(test7, spiral_matrix(7))) # True
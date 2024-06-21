import pandas as pd
import numpy as np

path = "483 Generate Matrix.xlsx"
test = pd.read_excel(path, usecols="A:T", skiprows=1, header=None)
segments = [[5, 6, 7, 8, 9],
            [0, 1, 2, 3, 4],
            [9, 8, 7, 6, 5],
            [4, 3, 2, 1, 0]]

patterns = [seg3 + seg2 + seg1 + seg4,
            seg4 + seg1 + seg2 + seg3,
            seg1 + seg4 + seg3 + seg2,
            seg2 + seg3 + seg4 + seg1]

final_matrix = np.concatenate([np.tile(pattern, (5, 1)) for pattern in patterns], axis=0)
final_matrix = pd.DataFrame(final_matrix)

print(np.array_equal(test, final_matrix))   # True

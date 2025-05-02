import pandas as pd
import numpy as np

path = "483 Generate Matrix.xlsx"
test = pd.read_excel(path, usecols="A:T", skiprows=1, header=None)

seg1 = [5, 6, 7, 8, 9]
seg2 = [0, 1, 2, 3, 4]
seg3 = [9, 8, 7, 6, 5]
seg4 = [4, 3, 2, 1, 0]

pattern1 = seg3 + seg2 + seg1 + seg4
pattern2 = seg4 + seg1 + seg2 + seg3
pattern3 = seg1 + seg4 + seg3 + seg2
pattern4 = seg2 + seg3 + seg4 + seg1

block1 = np.tile(pattern1, (5, 1))
block2 = np.tile(pattern2, (5, 1))
block3 = np.tile(pattern3, (5, 1))
block4 = np.tile(pattern4, (5, 1))

final_matrix = np.concatenate((block1, block2, block3, block4), axis=0)
final_matrix = pd.DataFrame(final_matrix)

print(np.array_equal(test, final_matrix))   # True

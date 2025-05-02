import pandas as pd
import numpy as np

def draw_diamond(size):
    M = np.full((2 * size - 1, 2 * size - 1), np.nan)

    for i in range(2 * size - 1):
        for j in range(2 * size - 1):
            M[i, j] = abs(abs(i - (size-1)) + abs(j - (size-1))) + 1

    M = pd.DataFrame(M).applymap(lambda x: chr(int(x) + 64) if x <= size else "")
    return M

print(draw_diamond(3))

#    0  1  2  3  4
# 0        C
# 1     C  B  C
# 2  C  B  A  B  C
# 3     C  B  C
# 4        C

print(draw_diamond(5))

#    0  1  2  3  4  5  6  7  8
# 0              E
# 1           E  D  E
# 2        E  D  C  D  E
# 3     E  D  C  B  C  D  E
# 4  E  D  C  B  A  B  C  D  E
# 5     E  D  C  B  C  D  E
# 6        E  D  C  D  E
# 7           E  D  E
# 8              E

print(draw_diamond(8))

#    0  1  2  3  4  5  6  7  8  9  10 11 12 13 14
# 0                        H
# 1                     H  G  H
# 2                  H  G  F  G  H
# 3               H  G  F  E  F  G  H
# 4            H  G  F  E  D  E  F  G  H
# 5         H  G  F  E  D  C  D  E  F  G  H
# 6      H  G  F  E  D  C  B  C  D  E  F  G  H
# 7   H  G  F  E  D  C  B  A  B  C  D  E  F  G  H
# 8      H  G  F  E  D  C  B  C  D  E  F  G  H
# 9         H  G  F  E  D  C  D  E  F  G  H
# 10           H  G  F  E  D  E  F  G  H
# 11              H  G  F  E  F  G  H
# 12                 H  G  F  G  H
# 13                    H  G  H
# 14                       H
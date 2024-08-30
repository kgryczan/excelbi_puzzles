import pandas as pd

def draw_ascii_star(number):
    matrix = [[""] * number for _ in range(number)]
    for i in range(number):
        matrix[i][number // 2] = "*"
        matrix[number // 2][i] = "*"
        matrix[i][i] = "*"
        matrix[i][number - i - 1] = "*"
    result = pd.DataFrame(matrix)
    return result

print(draw_ascii_star(5))
print(draw_ascii_star(7))
print(draw_ascii_star(9))
print(draw_ascii_star(11))
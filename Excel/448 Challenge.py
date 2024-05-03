import pandas as pd

test2 = pd.read_excel("448 Draw Inverted Triangle.xlsx", usecols="B:D", skiprows=1, nrows=2, header=None).rename(columns=lambda x: x - 1)
test3 = pd.read_excel("448 Draw Inverted Triangle.xlsx", usecols="B:F", skiprows=4, nrows=3, header=None).rename(columns=lambda x: x - 1) 
test4 = pd.read_excel("448 Draw Inverted Triangle.xlsx", usecols="B:H", skiprows=8, nrows=4, header=None).rename(columns=lambda x: x - 1) 
test7 = pd.read_excel("448 Draw Inverted Triangle.xlsx", usecols="B:N", skiprows=13, nrows=7, header=None).rename(columns=lambda x: x - 1)

def create_sequence_matrix(n):
    total_elements = n * (n + 1) // 2
    max_elements_in_row = n
    values = list(range(1, total_elements + 1))
    mat = [[None] * max_elements_in_row for _ in range(n)]
    start_index = 0
    for i in range(n):
        end_index = start_index + i
        mat[i][:i+1] = values[start_index:end_index+1]
        start_index = end_index + 1
    return mat

def flip_horizontal(mat):
    return [row[::-1] for row in mat]

def flip_vertical(mat):
    return mat[::-1]

def generate_upsidedown_triangle(n):
    mat_or = create_sequence_matrix(n)
    mat_fh = flip_horizontal(mat_or)
    mat_fv1 = flip_vertical(mat_or)
    mat_fv2 = flip_vertical(mat_fh)
    mat_fv2 = [row[:-1] for row in mat_fv2]
    mat_fin = [row1 + row2 for row1, row2 in zip(mat_fv2, mat_fv1)]
    mat_fin = pd.DataFrame(mat_fin)
    return mat_fin

print(generate_upsidedown_triangle(2).equals(test2)) # True
print(generate_upsidedown_triangle(3).equals(test3)) # True
print(generate_upsidedown_triangle(4).equals(test4)) # True
print(generate_upsidedown_triangle(7).equals(test7)) # True

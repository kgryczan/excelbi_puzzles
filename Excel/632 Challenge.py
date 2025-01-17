import pandas as pd
import numpy as np

path = "632 Create Triangle from Words.xlsx"
test1 = pd.read_excel(path, usecols="B:D", skiprows=1, nrows=2, header=None).fillna(' ').values
test2 = pd.read_excel(path, usecols="B:F", skiprows=4, nrows=3, header=None).fillna(' ').values
test3 = pd.read_excel(path, usecols="B:F", skiprows=8, nrows=3, header=None).fillna(' ').values
test4 = pd.read_excel(path, usecols="B:H", skiprows=12, nrows=4, header=None).fillna(' ').values
test5 = pd.read_excel(path, usecols="B:J", skiprows=17, nrows=6, header=None).fillna(' ').values

def triangular_numbers(n):
    return n * (n + 1) // 2

def draw_triangle_from_word(word):
    n = 1
    while triangular_numbers(n) < len(word):
        n += 1
    
    padded_word = word + "#" * (triangular_numbers(n) - len(word))
    word_chars = list(padded_word)
    word_split = [word_chars[triangular_numbers(i-1):triangular_numbers(i)] for i in range(1, n+1)]
    
    formatted_lines = []
    for line in word_split:
        formatted_line = ' '.join(line).center(n * 2 - 1)
        formatted_lines.append(list(formatted_line))
    
    formatted_matrix = np.array(formatted_lines, dtype=object)
    
    return formatted_matrix

words = ["thu", "moon", "excel", "skyjacking", "embezzlements"]

print((draw_triangle_from_word(words[0]) == test1).all())
print((draw_triangle_from_word(words[1]) == test2).all())
print((draw_triangle_from_word(words[2]) == test3).all())
print((draw_triangle_from_word(words[3]) == test4).all())
print((draw_triangle_from_word(words[4]) == test5).all())

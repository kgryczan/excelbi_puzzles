import pandas as pd
import numpy as np

path = "542 Squares from Strings.xlsx"
test_abc = pd.read_excel(path, sheet_name=None, usecols="C:E", skiprows=1, nrows=3, header=None).get('Sheet1').replace(np.nan, '', regex=True)
test_abcd = pd.read_excel(path, sheet_name=None, usecols="C:F", skiprows=5, nrows=4, header=None).get('Sheet1').replace(np.nan, '', regex=True)
test_microsoft = pd.read_excel(path, sheet_name=None, usecols="C:K", skiprows=10, nrows=9, header=None).get('Sheet1').replace(np.nan, '', regex=True)

def make_word_frame(word):
    n = len(word)
    word_frame = np.full((n, n), '', dtype=str)
    word_frame[0] = list(word)
    word_frame[:, 0] = list(word)
    word_frame[-1] = list(word[::-1])
    word_frame[:, -1] = list(word[::-1])
    return word_frame

print(all(make_word_frame("abc")==test_abc)) # True
print(all(make_word_frame("abcd")==test_abcd)) # True
print(all(make_word_frame("microsoft")==test_microsoft)) # True
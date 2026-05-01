import pandas as pd
import numpy as np

path = "900-999/968/968 Triangle Patterns.xlsx"
input1 = [
	int(x)
	for x in str(pd.read_excel(path, header=None, usecols="A", skiprows=1, nrows=1).iloc[0, 0]).split(",")
]
input2 = [
	int(x)
	for x in str(pd.read_excel(path, header=None, usecols="A", skiprows=5, nrows=1).iloc[0, 0]).split(",")
]
input3 = [
	int(x)
	for x in str(pd.read_excel(path, header=None, usecols="A", skiprows=8, nrows=1).iloc[0, 0]).split(",")
]

test1 = pd.read_excel(path, header=None, usecols="B:R", skiprows=1, nrows=3).to_numpy()
test2 = pd.read_excel(path, header=None, usecols="B:L", skiprows=5, nrows=2).to_numpy()
test3 = pd.read_excel(path, header=None, usecols="B:V", skiprows=8, nrows=6).to_numpy()


def build_pattern_matrix(amplitude, waves, symbol="X"):
	wave_unit = list(range(amplitude, 0, -1)) + list(range(2, amplitude + 1))
	wave = wave_unit * waves
	pattern = [wave[0]]
	for value in wave[1:]:
		if value != pattern[-1]:
			pattern.append(value)

	M = np.full((amplitude, len(pattern)), np.nan, dtype=object)
	for i, row_idx in enumerate(pattern):
		M[row_idx - 1, i] = symbol
	return M


M1 = build_pattern_matrix(input1[0], input1[1])
M2 = build_pattern_matrix(input2[0], input2[1])
M3 = build_pattern_matrix(input3[0], input3[1])


def compare_with_na(a, b):
	a = np.asarray(a, dtype=object)
	b = np.asarray(b, dtype=object)
	mask_a = pd.isna(a)
	mask_b = pd.isna(b)
	return np.array_equal(mask_a, mask_b) and np.array_equal(a[~mask_a], b[~mask_b])


print(compare_with_na(M1, test1)) # True
print(compare_with_na(M2, test2)) # True
print(compare_with_na(M3, test3)) # True


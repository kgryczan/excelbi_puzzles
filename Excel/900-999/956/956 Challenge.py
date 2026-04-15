import pandas as pd
import itertools
import math

path = "900-999/956/956 Minimum Digits to Remove to Make Perfect Square.xlsx"
input = pd.read_excel(path, usecols="A", nrows=11, skiprows=0)
test = pd.read_excel(path, usecols="B", nrows=11, skiprows=0)

def is_perfect_square(x):
	if pd.isna(x):
		return False
	if not isinstance(x, (int, float)):
		try:
			x = float(x)
		except (TypeError, ValueError):
			return False
	if not math.isfinite(x) or x < 0:
		return False
	if int(x) != x:
		return False
	x = int(x)
	s = math.isqrt(x)
	return s * s == x

def get_perfect_squares(num):
	digits = list(str(int(num)))
	perfect_squares = []
	n_digits = len(digits)

	if is_perfect_square(num):
		perfect_squares.append(int(num))

	if n_digits < 2:
		return ", ".join(str(x) for x in sorted(set(perfect_squares), key=lambda v: str(v)))

	for i in range(1, n_digits):
		keep = n_digits - i
		for combo in itertools.combinations(digits, keep):
			candidate = int("".join(combo))
			if is_perfect_square(candidate):
				perfect_squares.append(candidate)

	result = list(dict.fromkeys(perfect_squares))
	if not result:
		return ""
	max_len = max(len(str(x)) for x in result)
	filtered = [x for x in result if len(str(x)) == max_len]
	return ", ".join(str(x) for x in filtered)

result = input.copy()
result["perfect_squares"] = result["Numbers"].apply(get_perfect_squares)
print(result["perfect_squares"].equals(test["Answer Expected"]))


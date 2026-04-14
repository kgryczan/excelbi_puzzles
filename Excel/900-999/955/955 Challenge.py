import pandas as pd

path = "900-999/955/955 Longest Valid Parentheses.xlsx"
input = pd.read_excel(path, usecols="A", nrows=18, skiprows=0)
test = pd.read_excel(path, usecols="B", nrows=18, skiprows=0)


def longest_valid_parentheses(s):
	chars = list(s)
	def scan(seq, open_char, close_char):
		left = right = best = 0
		for char in seq:
			left += char == open_char
			right += char == close_char
			if left == right:
				best = max(best, left + right)
			elif right > left:
				left = right = 0
		return best
	return max(scan(chars, "(", ")"), scan(reversed(chars), ")", "("))


result = input['Data'].apply(longest_valid_parentheses)

print(result.equals(test['Answer Expected']))
# True
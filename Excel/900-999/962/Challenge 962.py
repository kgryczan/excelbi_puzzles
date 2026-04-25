import pandas as pd

path = "900-999/962/962 Recuce Till Single Digit Htrough Multiplication.xlsx"
input = pd.read_excel(path, usecols="A", nrows=9, skiprows=1)
test = pd.read_excel(path, usecols="B:C", nrows=9, skiprows=1)

def multiply_digits(x):
	digits = [int(d) for d in str(int(x))]
	product = 1
	for d in digits:
		product *= d
	return product

def persistence(x):
	count = 0
	x = int(x)
	while x >= 10:
		x = multiply_digits(x)
		count += 1
	return {"Persistence": count, "Final Digit": x}

results = input.copy()
results = results.join(results["Number"].apply(persistence).apply(pd.Series))

print(results[["Persistence", "Final Digit"]].equals(test))
# True

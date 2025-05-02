import pandas as pd

path = "658 Word Square Validation.xlsx"

M1 = pd.read_excel(path, usecols="B:C", nrows = 2, skiprows= 1, header=None).values
test1 = pd.read_excel(path, usecols="J", nrows=1, skiprows=1, header=None).values[0][0]
A1 = "Yes" if (M1 == M1.T).all() else "No"
print(A1 == test1) # True

M2 = pd.read_excel(path, usecols="B:D", nrows = 3, skiprows= 4, header=None).values
test2 = pd.read_excel(path, usecols="J", nrows=1, skiprows=4, header=None).values[0][0]
A2 = "Yes" if (M2 == M2.T).all() else "No"
print(A2 == test2) # True

M3 = pd.read_excel(path, usecols="B:E", nrows = 4, skiprows= 8, header=None).values
test3 = pd.read_excel(path, usecols="J", nrows=1, skiprows=8, header=None).values[0][0]
A3 = "Yes" if (M3 == M3.T).all() else "No"
print(A3 == test3) # True

M4 = pd.read_excel(path, usecols="B:F", nrows = 5, skiprows= 13, header=None).values
test4 = pd.read_excel(path, usecols="J", nrows=1, skiprows=13, header=None).values[0][0]
A4 = "Yes" if (M4 == M4.T).all() else "No"
print(A4 == test4) # True

M5 = pd.read_excel(path, usecols="B:G", nrows = 6, skiprows= 19, header=None).values
test5 = pd.read_excel(path, usecols="J", nrows=1, skiprows=19, header=None).values[0][0]
A5 = "Yes" if (M5 == M5.T).all() else "No"
print(A5 == test5) # True

M6 = pd.read_excel(path, usecols="B:H", nrows = 7, skiprows= 26, header=None).values
test6 = pd.read_excel(path, usecols="J", nrows=1, skiprows=26, header=None).values[0][0]
A6 = "Yes" if (M6 == M6.T).all() else "No"
print(A6 == test6) # True

M7 = pd.read_excel(path, usecols="B:I", nrows = 8, skiprows= 34, header=None).values
test7 = pd.read_excel(path, usecols="J", nrows=1, skiprows=34, header=None).values[0][0]
A7 = "Yes" if (M7 == M7.T).all() else "No"
print(A7 == test7) # True

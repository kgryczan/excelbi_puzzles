import pandas as pd

path = "617 Palintiples.xlsx"
test = pd.read_excel(path,  usecols="A", nrows=10)

def palindrome_divisors():
    count = 0
    for n in range(1, 10**9):
        if n % 10:
            s1 = str(n)
            s2 = s1[::-1]
            if s1 != s2 and not n % int(s2):
                yield n
                count += 1
                if count == 10:
                    break

results = list(palindrome_divisors())
df = pd.DataFrame(results, columns=['Palindrome Divisors'])

print(df['Palindrome Divisors'].equals(test['Answer Expected'])) # True
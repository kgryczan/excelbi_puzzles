import pandas as pd

path = "495 Sum of N Digit Palindrome Numbers.xlsx"
input = pd.read_excel(path, usecols = "A", skiprows = 1)
test  = pd.read_excel(path, usecols = "B:C", skiprows = 1)

def generate_all_palindromes(num_digits):
    if num_digits < 1:
        raise ValueError("Number of digits must be at least 1")
    if num_digits == 1:
        return list(range(10))
    half_digits = (num_digits + 1) // 2
    start_num = 10 ** (half_digits - 1)
    end_num = 10 ** half_digits - 1
    palindromes = []
    
    for i in range(start_num, end_num + 1):
        num_str = str(i)
        rev_str = num_str[::-1]
        if num_digits % 2 == 0:
            palindrome_str = num_str + rev_str
        else:
            palindrome_str = num_str + rev_str[1:]
        palindromes.append(int(palindrome_str))
    
    return palindromes

result = input.assign(palindromes = input['N'].map(generate_all_palindromes)) \
                .assign(Count = lambda x: x['palindromes'].map(len),
                        Sum = lambda x: x['palindromes'].map(sum)) \
                .loc[:, ['Count', 'Sum']]

print(result.equals(test)) # True
import pandas as pd

path = "531 Numbers Divisible after Removing a Digit.xlsx"
test = pd.read_excel(path, skiprows=1)

def transform_number(number):
    return [int(str(number)[:i] + str(number)[i+1:]) for i in range(len(str(number)))]

numbers = pd.DataFrame({'number': range(101, 1000001)})
numbers = numbers[numbers['number'] % 10 != 0]
numbers['new_number'] = numbers['number'].apply(transform_number)
numbers = numbers.explode('new_number')
numbers['new_number'] = pd.to_numeric(numbers['new_number'])
numbers = numbers.drop_duplicates(subset=['number', 'new_number'])

filtered_numbers = numbers[(numbers['number'] % numbers['new_number'] == 0) & (numbers['new_number'] != 1)]

result = filtered_numbers.groupby('number').agg(divisors=('new_number', lambda x: ', '.join(map(str, x)))).reset_index()

n1 = result.head(500)
n1.columns = test.columns

print(all(n1.eq(test))) # True
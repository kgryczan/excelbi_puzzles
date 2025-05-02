import pandas as pd

path = "526 Next 3 Palindromes.xlsx"
input = pd.read_excel(path, usecols="A")
test = pd.read_excel(path, usecols="B:D", names=['res1', 'res2', 'res3'])

def get_next_palindromes(num, cnt):
    num = str(num)
    nc = len(num)
    
    fh = num[:nc // 2]
    mid = num[nc // 2]
    ld = num[nc // 2 - 1]
    fd = num[nc // 2 + 1]
    
    if nc % 2 == 0:
        next_fh = [str(int(fh) + i - (mid < ld)) for i in range(1, cnt + 1)]
        palindromes = [fh + fh[::-1] for fh in next_fh]
    else:
        next_fh = [str(int(fh + mid) + i - (fd < ld)) for i in range(1, cnt + 1)]
        palindromes = [fh + fh[::-1][1:] for fh in next_fh]
    
    return palindromes

result = input.assign(res=input['Number'].apply(lambda x: get_next_palindromes(x, 3))).explode('res').reset_index(drop=True)
result['rownum'] = result.groupby('Number').cumcount() + 1
result = result.pivot(index='Number', columns='rownum', values='res').add_prefix('res').reset_index(drop=True)
result = result.astype('int64')
result.columns.name = None

print(result.equals(test))  # True

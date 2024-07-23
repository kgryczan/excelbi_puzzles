import pandas as pd
import string

def create_triangular_dataframe(letters):
    def triangular_number(n):
        return (n * (n + 1)) // 2
    
    n = max([i for i in range(1, 100) if triangular_number(i) <= len(letters)])
    num_rows = n + 1
    num_cols = n * 2 + 1
    df = pd.DataFrame("", index=range(num_rows), columns=range(num_cols))
    letters_idx = 0
    
    def fill_row(row_num, num_letters):
        nonlocal letters_idx
        start_col = (num_cols - (2 * num_letters - 1)) // 2
        for j in range(num_letters):
            df.iat[row_num, start_col + j * 2] = letters[letters_idx]
            letters_idx += 1
    
    for i in range(1, n + 1):
        fill_row(i - 1, i)
    
    fill_row(num_rows - 1, len(letters) - triangular_number(n))
    print(df)

# Example usage
create_triangular_dataframe(list(string.ascii_uppercase))

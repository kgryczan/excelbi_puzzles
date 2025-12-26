def tree(h):
    step = 4
    width = 2 * h * step + 1
    mid = width // 2
    m = [[' ' for _ in range(width)] for _ in range(h + 6)]
    m[0][mid] = '+'
    for i in range(h):
        for j in range(2 * i + 1):
            m[i + 1][mid - step * i + step * j] = '*' if j % 2 == 0 else '$'
    for idx in [-2, 0, 2]:
        m[h + 1][mid + idx] = '|'
        m[h + 2][mid + idx] = '|'
    for idx in range(-4, 5):
        m[h + 3][mid + idx] = '='
    for row in m:
        print(''.join(row))

tree(10)

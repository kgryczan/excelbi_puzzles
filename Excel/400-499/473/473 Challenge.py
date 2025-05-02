def print_banner_matrix(word):
    n = len(word)
    banner_matrix = [["" for _ in range(n * 3)] for _ in range(4)]
    for i in range(n):
        char = word[i]
        if char != " ":
            banner_matrix[0][(i * 3):(i * 3) + 3] = [" ", "_", " "]
            banner_matrix[1][(i * 3):(i * 3) + 3] = ["/", " ", "\\"]
            banner_matrix[2][(i * 3):(i * 3) + 3] = ["|", char, "|"]
            banner_matrix[3][(i * 3):(i * 3) + 3] = ["\\", "_", "/"]
        else:
            banner_matrix[0][(i * 3):(i * 3) + 3] = [" "] * 3
            banner_matrix[1][(i * 3):(i * 3) + 3] = [" "] * 3
            banner_matrix[2][(i * 3):(i * 3) + 3] = [" "] * 3
            banner_matrix[3][(i * 3):(i * 3) + 3] = [" "] * 3
    for row in banner_matrix:
        print("".join(row))

print_banner_matrix("EXCEL")
print_banner_matrix("MICROSOFT")
print_banner_matrix("POWER QUERY")
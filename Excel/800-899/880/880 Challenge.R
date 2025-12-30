layer_matrix <- function(n) {
  outer(1:(2 * n - 1), 1:(2 * n - 1), function(i, j) {
    pmax(abs(i - n), abs(j - n)) + 1
  })
}

print(layer_matrix(2))
print(layer_matrix(4))
print(layer_matrix(7))

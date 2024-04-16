M = matrix(NA, nrow = 12, ncol = 23)

for (i in 1:7) {
  M[i, ] = c(rep(NA, (23 - 2*i + 1)/2), rep('+', 2*i - 1), rep(NA, (23 - 2*i + 1)/2))
}

for (i in 8) {
  M[i, ] = c(rep(NA, (23 - 2*i + 1)/2), rep('=', 2*i - 1), rep(NA, (23 - 2*i + 1)/2))
}

for (i in 9:12) {
  M[i, ] = c(rep(NA, i - 9), rep('x', 23 - 2*(i - 9)), rep(NA, i - 9))
}

M

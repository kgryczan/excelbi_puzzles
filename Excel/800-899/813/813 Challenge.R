size = 5
M = matrix(NA_integer_, 2*size + 1, 2*size + 1)
M[size + 1, ] = c(-size:-1, 0, 1:size)
M[, size + 1] = c(size:1, 0, -1:-size)
idx = which(is.na(M), arr.ind = TRUE)
M[idx] = ifelse(idx[,1] + idx[,2] == size + 1 | idx[,1] - idx[,2] == size + 1, -size,
         ifelse(idx[,1] + idx[,2] == 3 * (size + 1) | idx[,2] - idx[,1] == size + 1, size, NA))
M
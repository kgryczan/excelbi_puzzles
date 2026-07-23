n <- 6

len <- c(n - 1, rep((n - 1):1, each = 2))
dir <- rbind(c(0, 1), c(1, 0), c(0, -1), c(-1, 0))

steps <- dir[
  rep((seq_along(len) - 1) %% 4 + 1, len),
  ,
  drop = FALSE
]

pos <- rbind(c(1, 1), cbind(1 + cumsum(steps[, 1]), 1 + cumsum(steps[, 2])))

result <- matrix(0, n, n)
result[pos] <- seq_len(n^2)

result

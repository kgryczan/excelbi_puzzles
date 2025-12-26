tree <- function(h) {
  step <- 4
  width <- 2 * h * step + 1
  mid <- width %/% 2

  m <- matrix(" ", h + 6, width)

  m[1, mid] <- "+"

  for (i in 0:(h - 1)) {
    for (j in 0:(2 * i)) {
      m[i + 2, mid - step * i + step * j] <- if (j %% 2 == 0) "*" else "$"
    }
  }

  m[(h + 2):(h + 3), mid + c(-2, 0, 2)] <- "|"
  m[h + 4, mid + (-4:4)] <- "="

  cat(apply(m, 1, paste0, collapse = ""), sep = "\n")
}

tree(10)

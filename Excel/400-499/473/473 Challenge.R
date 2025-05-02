print_banner_matrix <- function(word) {
  n <- nchar(word)
  banner_matrix <- matrix("", nrow = 4, ncol = n * 3)
  for (i in seq_len(n)) {
    char <- substr(word, i, i)
    if (char != " ") {
      banner_matrix[1, (i - 1) * 3 + 1:3] <- c(" ", "_", " ")
      banner_matrix[2, (i - 1) * 3 + 1:3] <- c("/", " ", "\\")
      banner_matrix[3, (i - 1) * 3 + 1:3] <- c("|", char, "|")
      banner_matrix[4, (i - 1) * 3 + 1:3] <- c("\\", "_", "/")
    } else {
      banner_matrix[1, (i - 1) * 3 + 1:3] <- rep(" ", 3)
      banner_matrix[2, (i - 1) * 3 + 1:3] <- rep(" ", 3)
      banner_matrix[3, (i - 1) * 3 + 1:3] <- rep(" ", 3)
      banner_matrix[4, (i - 1) * 3 + 1:3] <- rep(" ", 3)
    }
  }
  apply(banner_matrix, 1, function(row) cat(paste(row, collapse = ""), "\n"))
}

print_banner_matrix("EXCEL")
print_banner_matrix("MICROSOFT")
print_banner_matrix("POWER QUERY")

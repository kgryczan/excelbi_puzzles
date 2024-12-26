palindrome_divisors <- function() {
    results <- c()
    count <- 0
    for (n in 1:(10^9)) {
        if (n %% 10 != 0) {
            s1 <- as.character(n)
            s2 <- paste(rev(strsplit(s1, NULL)[[1]]), collapse = "")
            if (s1 != s2 && n %% as.integer(s2) == 0) {
                results <- c(results, n)
                count <- count + 1
                if (count == 8) {
                    break
                }
            }
        }
    }
    return(results)
}

results <- palindrome_divisors()
for (result in results) {
    print(result)
}

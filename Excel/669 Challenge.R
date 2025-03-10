library(tidyverse)
library(readxl)

path <- "Excel/669 Tech Numbers.xlsx"
test <- read_excel(path, range = "A1:A11") %>% pull()

is_tech_number <- function(n) {
    num_str <- as.character(n)
    len <- str_length(num_str)
    if (len %% 2 != 0) return(FALSE)
    half_len <- len / 2
    h1 <- as.integer(substr(num_str, 1, half_len))
    h2 <- as.integer(substr(num_str, half_len + 1, len))
    (h1 + h2)^2 == n
}

find_tech_numbers <- function(count = 10) {
    tech_numbers <- (1:10^4)^2 %>%
        keep(~ str_length(.) %% 2 == 0 && is_tech_number(.))
    head(tech_numbers, count)
}

result = find_tech_numbers(10)
all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE
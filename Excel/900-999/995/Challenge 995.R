library(tidyverse)
library(readxl)

path <- "900-999/995/995 Next Greater Distance.xlsx"
input <- read_excel(path, range = "A1:C21")
test <- read_excel(path, range = "D1:D21")

result <- input %>%
    group_by(Group) %>%
    mutate(
        Output = map_int(seq_along(Value), \(idx) {
            n <- length(Value)
            d <- seq_len(n - 1)
            match(
                TRUE,
                Value[((idx + d - 1) %% n) + 1] > Value[idx],
                nomatch = 0
            )
        })
    ) %>%
    ungroup()

all.equal(result$Output, test$`Answer Expected`)

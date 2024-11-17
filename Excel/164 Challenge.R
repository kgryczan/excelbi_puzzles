library(tidyverse)
library(readxl)

path = "Excel/164 First 18 Disarium Number.xlsx"
test  = read_excel(path, range = "A1:A19")

is_disarium <- function(num) {
  digits <- str_split(as.character(num), "") %>% unlist() %>% as.integer()
  positions <- seq_along(digits)
  sum(digits^positions) == num
}

disarium_numbers <- integer(18)
count <- 0
n <- 1

while (count < 18) {
  if (is_disarium(n)) {
    count <- count + 1
    disarium_numbers[count] <- n
  }
  n <- n + 1
}

all.equal(disarium_numbers, test$`Disarium Numbers`, check.attributes = FALSE)
#> [1] TRUE
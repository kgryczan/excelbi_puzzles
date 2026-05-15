library(tidyverse)
library(readxl)

path <- "900-999/978/978 Leader Cumulative Basis.xlsx"
input <- read_excel(path, range = "A1:C29")
test <- read_excel(path, range = "D1:D29")

result = input %>%
  mutate(cust_cumsum = cumsum(Amount), .by = Customer) %>%
  mutate(
    `Answer Expected` = (cummax(cust_cumsum) == cust_cumsum) %>% as.integer()
  )

all.equal(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE

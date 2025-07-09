library(tidyverse)
library(readxl)
library(primes)

path = "Excel/200-299/242/242 Type of Prime Numbers.xlsx"
input = read_excel(path, range = "A1:B9")
test  = read_excel(path, range = "C1:C9")

result = input %>%
  mutate(`Answer Expected` = case_when(
    is_prime(Number1) & is_prime(Number2) ~
      case_when(
        abs(Number2 - Number1) == 2 ~ "Twin Prime",
        abs(Number2 - Number1) == 4 ~ "Cousin Prime",
        abs(Number2 - Number1) == 6 ~ "Sixy Prime",
        TRUE ~ "None"
      ),
    TRUE ~ "None"
  ))

all.equal(result$`Answer Expected`, test$`Answer Expected`) 
# > [1] TRUE
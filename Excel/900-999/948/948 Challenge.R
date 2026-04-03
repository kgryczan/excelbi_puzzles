library(tidyverse)
library(readxl)

path <- "900-999/948/948 Remove Pairs.xlsx"
input <- read_excel(path, range = "A1:A15")
test <- read_excel(path, range = "B1:B15") %>%
  replace_na(list(`Answer Expected` = ""))

result = input %>%
  mutate(
    `Answer Expected` = map_chr(
      Data,
      ~ {
        acc <- accumulate(
          1:100,
          ~ str_replace_all(.x, "(.)\\1", ""),
          .init = .x
        )
        acc[which(acc == lag(acc))[1]]
      }
    )
  )

all.equal(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE

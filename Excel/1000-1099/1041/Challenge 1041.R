library(tidyverse)
library(readxl)

path <- "1000-1099/1041/1041 Grouping.xlsx"
input <- read_excel(path, range = "A2:A22")
test <- read_excel(path, range = "C2:D5")

result <- input %>%
  separate_wider_delim(
    Data,
    delim = " : ",
    names = c("Category", "Code", "Type", "Amount")
  ) %>%
  separate_wider_delim(
    Category,
    delim = ">",
    names = c("Category", "L1", "L2")
  ) %>%
  summarise(
    Amount = sum(
      as.numeric(Amount) *
        case_when(
          Type == "Return" ~ -1,
          Type == "Promotion" ~ 0,
          TRUE ~ 1
        )
    ),
    .by = Category
  ) %>%
  arrange(Category)

all.equal(result, test)

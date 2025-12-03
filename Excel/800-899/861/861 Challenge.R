library(tidyverse)
library(readxl)

path <- "Excel/800-899/861/861 Transpose.xlsx"
input <- read_excel(path, sheet = 2, range = "A2:B6", col_names = TRUE)
test <- read_excel(path, sheet = 2, range = "D2:G10")

result = input %>%
  mutate(across(everything(), ~ str_replace_all(., " ", ""))) %>%
  mutate(
    Company = str_split(Company, ";|,"),
    Revenue = str_split(Revenue, ",")
  ) %>%
  unnest(c(Company, Revenue)) %>%
  extract(
    Company,
    regex = "^([A-Za-z]+)-(\\d+):\\s*(.+)$",
    into = c("Code", "ID", "Company")
  ) %>%
  mutate(Revenue = as.numeric(Revenue), ID = as.numeric(ID)) %>%
  arrange(Code, Company)

all.equal(result, test)
# [1] TRUE

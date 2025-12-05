library(tidyverse)
library(readxl)

path <- "Excel/800-899/863/863 Transpose.xlsx"
input <- read_excel(path, range = "A2:A13")
test <- read_excel(path, range = "C2:F5")

result = input %>%
  mutate(
    Date = ifelse(str_detect(Data, "Group"), NA, Data) %>% as.numeric()
  ) %>%
  fill(Date) %>%
  filter(Date != Data) %>%
  mutate(
    Date = janitor::excel_numeric_to_date(Date) %>% as.POSIXct(),
    Group = str_extract(Data, "(?<=Group )[A-Z]"),
    Item = str_extract(Data, "(?<=Item)[0-9]"),
    Amount = str_extract(Data, "[0-9]+$") %>% as.numeric()
  ) %>%
  select(-Data) %>%
  arrange(Date, Group) %>%
  summarise(
    Groups = paste0(unique(Group), collapse = ", "),
    Items = paste0(unique(Item), collapse = ", "),
    Total_Amount = sum(Amount),
    .by = Date
  )

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE

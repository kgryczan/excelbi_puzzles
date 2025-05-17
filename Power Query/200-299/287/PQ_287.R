library(tidyverse)
library(readxl)

path = "Power Query/200-299/287/PQ_Challenge_287.xlsx"
input = read_excel(path, range = "A1:A21")
test = read_excel(path, range = "C1:F5")

result = input %>%
  mutate(
    Category = case_when(
      str_detect(`Medal Table`, "^[A-Za-z]+$") & str_length(`Medal Table`) > 2 ~
        "Country",
      str_detect(`Medal Table`, "^[A-Z]+$") & str_length(`Medal Table`) == 2 ~
        "Country Code",
      TRUE ~ NA_character_
    )
  ) %>%
  mutate(
    Category = case_when(
      lag(Category, n = 1) == "Country Code" ~ "Gold",
      lag(Category, n = 2) == "Country Code" ~ "Silver",
      lag(Category, n = 3) == "Country Code" ~ "Bronze",
      TRUE ~ Category
    )
  ) %>%
  mutate(group = cumsum(Category == "Country")) %>%
  pivot_wider(names_from = Category, values_from = `Medal Table`) %>%
  select(-group) %>%
  mutate(across(
    c(Gold, Silver, Bronze),
    ~ as.numeric(str_remove_all(.x, "\\D"))
  )) %>%
  mutate(`Total Points` = Gold * 3 + Silver * 2 + Bronze * 1) %>%
  select(Country, `Country Code`, `Total Points`) %>%
  mutate(Rank = dense_rank(desc(`Total Points`))) %>%
  arrange(Rank, Country)

all.equal(result, test)
#> [1] TRUE

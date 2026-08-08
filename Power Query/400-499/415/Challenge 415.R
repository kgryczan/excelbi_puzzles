library(tidyverse)
library(readxl)

path <- "400-499/415/PQ_Challenge_415.xlsx"
input <- read_excel(path, range = "A1:A22")
test <- read_excel(path, range = "C1:F9")

result <- input %>%
  separate_wider_delim(cols = 1, delim = ",", names_sep = "_") %>%
  janitor::row_to_names(1) %>%
  pivot_longer(
    cols = matches("^(Plan|Actual) \\d{4}$"),
    names_to = c(".value", "Year"),
    names_pattern = "(Plan|Actual) (\\d{4})"
  ) %>%
  mutate(
    Year = as.integer(Year),
    across(c(Plan, Actual), as.numeric)
  ) %>%
  arrange(Category) %>%
  summarise(
    Actual = sum(Actual, na.rm = T),
    Plan = sum(Plan, na.rm = T),
    .by = c(Category, Year)
  ) %>%
  mutate(
    Category = ifelse(Year == 2023, Category, NA_character_),
    `Qtr-Yr` = ifelse(Year == 2023, paste0("Q1-", Year), paste0("Q2-", Year))
  ) %>%
  select(-Year) %>%
  relocate(`Qtr-Yr`, .after = Category)

all.equal(result, test)

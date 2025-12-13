library(tidyverse)
library(readxl)
library(glue)
library(janitor)

path <- "Power Query/300-399/347/PQ_Challenge_347 - Table Decomposition.xlsx"
input1 <- read_excel(path, range = "A1:F6")
input2 <- read_excel(path, range = "A8:B11")
test <- read_excel(path, range = "I1:P20")

cartesian_product <- crossing(
  input1 %>% mutate(ID = glue("ID{row_number()}") %>% as.character()),
  input2
)

result = cartesian_product %>%
  mutate(
    `Activity ID` = glue("{`Sub Table`}_{ID}") %>% as.character(),
    Quantity = Quantity * `%`,
    `Total Weight` = Quantity * `Unit Weight`
  ) %>%
  select(
    `Sub Table`,
    `Activity ID`,
    `Activity Name`,
    Unit,
    Quantity,
    `Unit Weight`,
    `Total Weight`,
    Chainage,
    `Resource Name`
  ) %>%
  arrange(`Activity ID`)

subs = result %>%
  summarise(
    `Total Weight` = sum(`Total Weight`),
    .by = `Sub Table`
  ) %>%
  mutate(
    `Sub Table`,
    `Activity ID` = "TOTAL",
    `Activity Name` = NA,
    Unit = NA,
    Quantity = NA,
    `Unit Weight` = NA,
    `Total Weight`,
    Chainage = NA,
    `Resource Name` = NA
  )

total = result %>%
  summarise(
    `Total Weight` = sum(`Total Weight`)
  ) %>%
  mutate(
    Chainage = NA,
    `Resource Name` = NA,
    Unit = NA,
    Quantity = NA,
    `Unit Weight` = NA,
    `Activity ID` = "GRAND TOTAL",
    `Activity Name` = NA,
    .data = .,
    `Total Weight`,
    `Sub Table` = NA
  )

final_result = bind_rows(
  result %>% filter(`Sub Table` == "Subtable-1"),
  subs %>% filter(`Sub Table` == "Subtable-1"),
  result %>% filter(`Sub Table` == "Subtable-2"),
  subs %>% filter(`Sub Table` == "Subtable-2"),
  result %>% filter(`Sub Table` == "Subtable-3"),
  subs %>% filter(`Sub Table` == "Subtable-3"),
  total
) %>%
  select(-`Sub Table`)

all.equal(final_result, test, check.attributes = FALSE)

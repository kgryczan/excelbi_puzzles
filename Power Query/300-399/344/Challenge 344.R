library(tidyverse)
library(readxl)

path <- "Power Query/300-399/344/PQ_Challenge_344.xlsx"
input <- read_excel(path, range = "A1:A17")
test <- read_excel(path, range = "C1:I16")

result = input %>%
  rename(Value = 1) %>%
  filter(!is.na(Value)) %>%
  mutate(
    Location = ifelse(
      str_detect(Value, "Location"),
      str_replace_all(Value, "Location: ", ""),
      NA
    )
  ) %>%
  fill(Location) %>%
  filter(!str_detect(Value, "Location")) %>%
  separate_wider_delim(
    Value,
    delim = ",",
    names_sep = "_",
    too_few = "align_start"
  ) %>%
  rename(
    Category = Value_1,
    SKU = Value_2,
    Jan_Stock = Value_3,
    Jan_Received = Value_4,
    Feb_Stock = Value_5,
    Feb_Received = Value_6,
    Mar_Stock = Value_7,
    Mar_Received = Value_8
  ) %>%
  select(Location, everything(), -Value_9) %>%
  filter(Category != "Category") %>%
  pivot_longer(
    cols = -c(Location, Category, SKU),
    names_to = c("Month", ".value"),
    names_sep = "_"
  ) %>%
  filter(Stock != "") %>%
  mutate(
    `Starting Stock` = as.integer(Stock),
    `Received Stock` = as.integer(Received)
  ) %>%
  select(-c(Stock, Received)) %>%
  mutate(
    Sold = `Starting Stock` + `Received Stock` - lead(`Starting Stock`),
    .by = c(Location, Category)
  )


all.equal(result, test)

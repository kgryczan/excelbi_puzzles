library(tidyverse)
library(readxl)

input <- read_excel("Excel/800-899/803/803 Max & Min.xlsx", range = "A2:I7")
test  <- read_excel("Excel/800-899/803/803 Max & Min.xlsx", range = "K2:M9")

result <- input %>%
  pivot_longer(-Name, names_to = "Year", values_to = "Value") %>%
  mutate(Value = as.integer(Value), Year = as.integer(Year)) %>%
  filter(Value %in% range(Value)) %>%
  mutate(Category = ifelse(Value == min(Value), "Min", "Max")) %>%
  arrange(Category, Name) %>%
  select(Category, Name, Year) %>%
  mutate(Category = ifelse(row_number() == 1, Category, NA_character_), .by = Category)

all.equal(result, test, check.attributes = FALSE)

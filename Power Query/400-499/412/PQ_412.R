library(tidyverse)
library(readxl)

path <- "400-499/412/PQ_Challenge_412.xlsx"
input <- read_excel(path, range = "A1:C21")
test <- read_excel(path, range = "E1:K6")
categories <- c("Electrical", "Mechanical", "Plumbing", "HVAC", "Safety")

result <- input %>%
  separate_rows(Detail, sep = "\\|") %>%
  separate(Detail, into = c("Category", "Value"), sep = ":") %>%
  mutate(Value = as.numeric(Value)) %>%
  summarise(Value = sum(Value), .by = c(Technician, Category)) %>%
  pivot_wider(
    names_from = Category,
    values_from = Value,
    values_fill = 0,
    values_fn = sum
  ) %>%
  select(Technician, all_of(categories)) %>%
  mutate(Total = rowSums(across(all_of(categories))))

result <- bind_rows(
  result,
  result %>%
    summarise(
      Technician = "Total",
      across(where(is.numeric), sum)
    )
)

all.equal(result, test)
# TRUE

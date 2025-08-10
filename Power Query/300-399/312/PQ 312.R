library(tidyverse)
library(readxl)
library(janitor)

path = "Power Query/300-399/312/PQ_Challenge_312.xlsx"
input = read_excel(path, range = "A1:M11")
test  = read_excel(path, range = "A15:H21")

result = input %>%
  mutate(
    Category = ifelse(Column1 == "Category", Column2, NA),
    State = ifelse(Column3 == "State", Column4, NA),
    Year = ifelse(Column5 == "Year", Column6, NA)) %>%
  fill(Category, State, Year) %>%
  filter(Column1 != "Category") %>%
  row_to_names(row_number = 1) %>%
  select(Category = `Home Loan`, State = Alabama, Year = `2023`, Customer = Months, everything()) %>%
  filter(Customer != "Months") %>%
  pivot_longer(
    cols = -c(Category, State, Year, Customer),
    names_to = "Month",
    values_to = "Amount"
  ) %>%
  mutate(Amount = as.numeric(Amount),
         Year = as.numeric(Year),
         quarter = recode(Month,
           Jan = "Q1", Feb = "Q1", Mar = "Q1",
           Apr = "Q2", May = "Q2", Jun = "Q2",
           Jul = "Q3", Aug = "Q3", Sep = "Q3",
           Oct = "Q4", Nov = "Q4", Dec = "Q4")) %>%
  select(-Month) %>%
  pivot_wider(names_from = quarter,
              values_from = Amount,
              values_fn = sum) 

all.equal(result, test, check.attributes = FALSE)
# > [1] TRUE
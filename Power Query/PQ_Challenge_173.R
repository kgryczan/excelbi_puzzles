library(tidyverse)
library(readxl)
library(glue)

input = read_excel("Power Query/PQ_Challenge_173.xlsx", range = "A1:B731")
test  = read_excel("Power Query/PQ_Challenge_173.xlsx", range = "D1:H27")

result1 = input %>%
  mutate(quarter = quarter(Date),
         year = year(Date),
         month = month(Date, label = TRUE, locale = "en"),
         month_num = month(Date)) %>%
  summarise(`Total Sale` = sum(Sale), .by = c("year", "quarter", "month", "month_num")) %>%
  mutate(years_row = row_number(),
         sales_perc = `Total Sale` / sum(`Total Sale`),
         .by = "year") %>%
  mutate(quarter_row = row_number(), .by = c("year","quarter")) %>%
  mutate(display_year = ifelse(years_row == 1, year, NA_character_),
         display_quarter = ifelse(quarter_row == 1, quarter, NA_integer_)) %>%
  select(year, Year = display_year, Quarter = display_quarter, Month = month, month_num, `Total Sale`, `Sale %` = sales_perc)

totals = result1 %>%
  summarise(`Total Sale` = sum(`Total Sale`), `Sale %` = sum(`Sale %`), .by = "year") %>%
  mutate(Year = glue("{year} Total") %>% as.character(),
         Quarter = NA_integer_,
         Month = NA_character_,
         month_num = NA_integer_) %>%
  select(year, Year, Quarter, Month, `Total Sale`, `Sale %`)

result = bind_rows(result1, totals) %>%
  arrange(year, month_num) %>%
  select(-c(year, month_num))

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
# 
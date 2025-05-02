library(tidyverse)
library(readxl)
library(english)

path = "Excel/507 Lexically Sorted MDY Dates.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B4")  

result = input %>%
  mutate(parts = str_match(Dates, '(\\d{2})(\\d{2})(\\d{4})'),
         lit_month = month.name[as.integer(parts[,2])],
         lit_day = as.character(english(as.integer(parts[,3]))),
         lit_year = as.character(english(as.integer(parts[,4])))) %>%
  mutate(
    is_alphabetical = pmap_lgl(list(lit_month, lit_day, lit_year), 
                               ~ {
                                 lit_date <- c(..1, ..2, ..3)
                                 identical(lit_date, sort(lit_date))
                               })
  ) %>%
  filter(is_alphabetical) %>%
  select(`Expected Answer` = Dates)

identical(result, test)
# [1] TRUE

library(tidyverse)
library(readxl)

path = "Excel/667 Pivot Problem.xlsx"
input = read_excel(path, range = "A1:B21")
test  = read_excel(path, range = "D2:J11")

result = input %>%
       mutate(`Month-Day` = month(Date, label = TRUE, abbr = TRUE, locale = "en"),
                             wday = wday(Date, label = TRUE, abbr = TRUE, week_start = 1, locale = "en")) %>%
       select(-Date) %>%
       mutate(across(c(`Month-Day`, wday), as.factor)) %>%
       summarise(Sales = paste(Sales, collapse = ", "), .by = c('Month-Day', wday)) %>%
       pivot_wider(names_from = wday, values_from = Sales, names_sort = TRUE) %>%
       mutate(`Month-Day` = as.character(`Month-Day`))

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE
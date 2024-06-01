library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_187.xlsx", range = "A1:C12")
test  = read_excel("Power Query/PQ_Challenge_187.xlsx", range = "E1:G30")

all <- expand_grid(Continent = unique(sort(input$Continent)), Year = unique(sort(input$Year)))

result1 <- all %>%
  left_join(input, by = c("Continent", "Year")) %>%
  mutate(Sales = replace_na(Sales, 0),
         Year = as.character(Year))

years <- unique(sort(result1$Year))

empty_row <- tibble(Continent = NA, Year = NA, Sales = NA_real_)

totals <- map_dfr(years, ~ {
  yearly_data <- result1 %>%
    filter(Year == .x)
  total_row <- summarise(yearly_data, Continent = "TOTAL", Year = .x, Sales = sum(Sales))
  bind_rows(yearly_data, total_row, empty_row)
})

grand_total <- summarise(result1, Continent = "GRAND TOTAL", Year = "2010-2013", Sales = sum(Sales))

result <- bind_rows(totals, grand_total)

identical(result, test)
# [1] TRUE

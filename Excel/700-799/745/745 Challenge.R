library(tidyverse)
library(readxl)

path = "Excel/700-799/745/745 Financial Pivot.xlsx"
input = read_excel(path, range = "A2:D16")
test  = read_excel(path, range = "F2:I6")

result = input %>%
  fill(Company) %>%
  summarise(`Total Revenue` = sum(Revenue, na.rm = TRUE),
            `Total Cost` = sum(Cost, na.rm = TRUE),
            .by = Company) %>%
  mutate(`Total Profit` = `Total Revenue` - `Total Cost`) %>%
  janitor::adorn_totals("row", name = "Grand Total") %>% 
  as_tibble() 

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
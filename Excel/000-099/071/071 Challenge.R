library(tidyverse)
library(readxl)

path = "Excel/071 No of Wins.xlsx"
input = read_excel(path, sheet = "Sheet2", range = "A1:B22")
test  = read_excel(path, sheet = "Sheet2", range = "C2:E8")

result = input %>%
  mutate(`Times Won` = n(), .by = Champion) %>%
  summarise(`Years of Winning` = str_c(Year, collapse = ", "),
            .by = c(`Times Won`, Champion)) %>%
  slice_max(`Times Won`, n = 4) %>%
  arrange(desc(`Times Won`), Champion) %>%
  select(2,1,3)

all.equal(result, test)
#> [1] TRUE
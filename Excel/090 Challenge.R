library(tidyverse)
library(readxl)

path = "Excel/090 Fourth Transaction.xlsx"
input = read_excel(path, range = "A1:B20")
test  = read_excel(path, range = "D2:E6", col_types = "text") %>% filter(`Breakdown Date` != "NA")

result = input %>%
  mutate(rn = row_number(),
         n = n(), 
         .by = `Machine ID`) %>%
  filter(n > 4 & rn == 4) %>%
  arrange(`Machine ID`)

cbind(result, test)

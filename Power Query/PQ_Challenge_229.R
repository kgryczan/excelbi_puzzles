library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_229.xlsx"
input = read_excel(path, range = "A1:D6")
test  = read_excel(path, range = "F1:H16")

result = input %>%
  mutate(days = as.numeric(as.Date(`To Date`) - as.Date(`From Date`)) + 1, 
         daily = Amount / days) %>%
  rowwise() %>%
  mutate(date = list(seq(`From Date`, `To Date`, by = "day"))) %>%
  unnest(date) %>%
  mutate(`Month - Year` = paste0(str_pad(month(date), width = 2, "0", side = "left"), "-", str_sub(year(date), 3, 4))) %>%
  summarise(Amount = round(sum(daily),0), .by = c(Transaction, `Month - Year`))

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
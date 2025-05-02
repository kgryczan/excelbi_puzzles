library(tidyverse)
library(readxl)

path = "Excel/158 Highest Duration.xlsx"
input = read_excel(path, range = "A1:B20")
test  = read_excel(path, range = "D2:E7")

result = input %>%
  extract(col = "Years", into = c("Start", "End"), regex = "(\\d+)-(\\d+)") %>%
  mutate(Start = as.numeric(Start), End = as.numeric(End)) %>%
  mutate(Duration = End - Start) %>%
  slice_max(n=3, order_by = Duration)

all.equal(result$Duration, test$Duration)
# [1] TRUE
library(tidyverse)
library(readxl)

path <- "Excel/800-899/895/895 Max Sales.xlsx"
input <- read_excel(path, range = "A2:F51")
test <- read_excel(path, range = "H2:J9")

result = input %>%
  mutate(Amount = Price * Units, Quarter = floor_date(Date, "quarter")) %>%
  group_by(Quarter, SalesRep) %>%
  summarise(Total_Sales = sum(Amount)) %>%
  filter(Total_Sales == max(Total_Sales)) %>%
  ungroup() %>%
  summarise(
    Name = str_c(SalesRep, collapse = ", "),
    Amount = first(Total_Sales),
    .by = Quarter
  ) %>%
  mutate(Quarter = paste0("Q", quarter(Quarter), "-", year(Quarter)))

all.equal(result, test)
# [1] TRUE

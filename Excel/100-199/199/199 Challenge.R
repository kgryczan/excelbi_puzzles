library(tidyverse)
library(readxl)

path = "Excel/199 Month & Day Sum Equal to Year.xlsx"
input = read_excel(path, range = "A1:B6")
test  = read_excel(path, range = "D1:F6")

result = input %>%
  mutate(days = map2(`From Date`, `To Date`, seq, by = "1 day")) %>%
  unnest(days) %>%
  filter(year(days)%% 100 == month(days) + day(days)) %>%
  group_by(`From Date`, `To Date`) %>%
  summarise(Count = n(),
            `Min Date` = min(days),
            `Max Date` = max(days)) %>%
  ungroup() %>%
  arrange(`Max Date`)%>%
  select(- `From Date`, - `To Date`)

all.equal(result, test)
#> [1] TRUE
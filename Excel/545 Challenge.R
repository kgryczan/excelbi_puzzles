library(tidyverse)
library(readxl)

path = "Excel/545 Ranking the Players.xlsx"
input = read_excel(path, range = "A2:A11")
test  = read_excel(path, range = "C2:E8")

result = input %>%
  separate_rows(`Match Results`, sep = "") %>%
  filter(`Match Results` != "") %>%
  mutate(Players = str_to_lower(`Match Results`),
         case_point = if_else(`Match Results` == toupper(`Match Results`), 1, -1)) %>%
  summarise(Points = sum(case_point), .by = Players) %>%
  mutate(Rank = dense_rank(desc(Points)) %>% as.numeric()) %>%
  arrange(Rank, Players)

identical(result, test)
# [1] TRUE

library(tidyverse)
library(readxl)

path = "Excel/061 Teams Max Goals Same.xlsx"
input = read_excel(path, range = "A1:D11")
test  = read_excel(path, range = "F2:G7")

result = input %>%
  separate(Result, into = c("Home", "Away"), sep = "-") %>%
  mutate(`Total Goals` = as.numeric(Home) + as.numeric(Away)) %>%
  mutate(n = n(), .by = `Total Goals`) %>%
  filter(n > 1) %>%
  select(Match, `Total Goals`) %>% 
  arrange(desc(`Total Goals`))

identical(result, test)
#> [1] TRUE
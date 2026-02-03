library(tidyverse)
library(readxl)

path <- "Excel/900-999/905/905 Maxed Priced Houses.xlsx"
input <- read_excel(path, range = "A2:D52")
test <- read_excel(path, range = "F2:I6")

result = input %>%
  filter(`Listed Price` == max(`Listed Price`), .by = c(Zone, Type)) %>%
  summarise(
    Houses = paste0(`House ID`, collapse = ", "),
    .by = c(Zone, Type, `Listed Price`)
  ) %>%
  select(-`Listed Price`) %>%
  pivot_wider(names_from = Type, values_from = Houses) %>%
  rename(`Zone-Type` = Zone) %>%
  arrange(`Zone-Type`)

print(result == test)
# one inconsistency due to different ordering of house IDs in a cell

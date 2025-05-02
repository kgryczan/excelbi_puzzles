library(tidyverse)
library(readxl)
library(glue)

path = "Power Query/PQ_Challenge_238.xlsx"
input = read_excel(path, range = "A1:C12")
test  = read_excel(path, range = "E1:F6")

result = input %>%
  pivot_wider(names_from = Status, values_from = Store, values_fn = length) %>%
  mutate(Status = case_when(
    is.na(Open) & !is.na(Closed) ~ glue("Closed-All {Closed}"),
    !is.na(Open) & is.na(Closed) ~ glue("Open-All {Open}"),
    TRUE ~ glue("Open-{Open}, Closed-{Closed}")
  ) %>% as.character()) %>%
  select(Item, Status)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE
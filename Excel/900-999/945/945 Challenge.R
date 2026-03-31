library(tidyverse)
library(readxl)
library(glue)

path <- "900-999/945/945 Extract Data.xlsx"
input <- read_excel(path, range = "A2:A26")
test <- read_excel(path, range = "C2:E5")

result = input %>%
  filter_out(Data == "---") %>%
  separate_wider_delim(Data, delim = ": ", names = c("Name", "Value")) %>%
  mutate(group = cumsum(Name == "USER")) %>%
  pivot_wider(names_from = Name, values_from = Value) %>%
  filter(DATE == "2026-03-30") %>%
  mutate(
    `Final Status` = case_when(
      STATUS == "Pending" ~ as.character(glue("Pending ({SIZE})")),
      TRUE ~ STATUS
    )
  ) %>%
  select(Username = USER, Action = ACTION, `Final Status`)

all.equal(result, test)
# > [1] TRUE

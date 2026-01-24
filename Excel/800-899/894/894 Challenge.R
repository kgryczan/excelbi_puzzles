library(tidyverse)
library(readxl)

path <- "Excel/800-899/894/894 Split Stack.xlsx"
input <- read_excel(path, range = "A2:A22")
test <- read_excel(path, range = "C2:E33")

result = input %>%
  separate(
    1,
    into = c("first", "rest"),
    sep = ",",
    extra = "merge",
    fill = "right"
  ) %>%
  separate_wider_delim(
    rest,
    delim = ",",
    names_sep = "_",
    too_few = "align_start"
  ) %>%
  separate_longer_delim(c(rest_1, rest_2), delim = "|") %>%
  rename(TicketID = first, Items = rest_1, Costs = rest_2) %>%
  mutate(TicketID = as.numeric(TicketID), Costs = as.numeric(Costs))

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE

library(tidyverse)
library(readxl)

path <- "400-499/407/PQ_Challenge_407.xlsx"
input <- read_excel(path, range = "A1:A22")
test <- read_excel(path, range = "C1:G11")

result <- input %>%
  mutate(
    ID = str_match(
      Data,
      regex("(?i)\\b(?:identifier|emp_id|id)\\s*:\\s*(\\d+)")
    )[, 2] %>%
      as.numeric()
  ) %>%
  mutate(Data = str_replace_all(Data, "[;~,]", "|")) %>%
  separate_longer_delim(Data, delim = "|") %>%
  filter_out(str_detect(Data, "id|ID|Id")) %>%
  mutate(
    Name = str_match(Data, regex("Name:\\s([A-Za-z]+(?:\\s+[A-Za-z]+)?)"))[, 2],
    Dept = str_match(
      Data,
      regex("(?:Dept|Department|Division):\\s([A-Za-z]+)")
    )[, 2],
    Loc = str_match(Data, regex("(?:Location|City):\\s([A-Za-z]+)"))[, 2],
    Status = str_match(
      Data,
      regex("(?:State|state|Status|status):\\s([A-Za-z]+(?:\\s+[A-Za-z]+)?)")
    )[, 2]
  ) %>%
  select(-Data) %>%
  pivot_longer(-ID, names_to = "topic", values_to = "value") %>%
  na.omit() %>%
  pivot_wider(names_from = "topic", values_from = "value")

all.equal(result, test)
# True

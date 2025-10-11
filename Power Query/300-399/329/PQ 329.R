library(tidyverse)
library(readxl)

path = "Power Query/300-399/329/PQ_Challenge_329.xlsx"
input = read_excel(path, range = "A1:C12")
test  = read_excel(path, range = "E1:F18")

result = input %>%
  fill(everything()) %>%
  mutate(Capital = str_remove(Cities, " \\(C\\)"),
         IsCapital = str_detect(Cities, "\\(C\\)")) %>%
  summarise(
    Capital = ifelse(any(IsCapital), first(Capital[IsCapital]), "None"),
    `Other Cities` = ifelse(any(!IsCapital), paste(Cities[!IsCapital], collapse = ", "), "None"),
    .by = c(Country, State)
  ) %>%
  mutate(rn = row_number()) %>%
  pivot_longer(-rn, names_to = "Type", values_to = "City") %>%
  filter(!(Type == "Country" & duplicated(City))) %>%
  select(-rn) %>%
  replace_na(list(City = "None"))

colnames(result) = colnames(test)

all.equal(result, test)
# TRUE
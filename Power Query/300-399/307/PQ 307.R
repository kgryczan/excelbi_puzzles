library(tidyverse)
library(readxl)
library(charcuterie)

path = "Power Query/300-399/307/PQ_Challenge_307.xlsx"
input = read_excel(path, range = "A1:C249")
test  = read_excel(path, range = "E1:E2") %>% pull()

result = input %>%
  mutate(
    sort_letter = map_chr(`Alpha-3 Code`, ~ paste0(sort(chars(.x)), collapse = "")),
    sort_digits = map_chr(Numeric, ~ paste0(sort(chars(.x)), collapse = ""))
  )

r1 <- result %>% filter(sort_letter %in% names(which.max(table(sort_letter))))
r2 <- result %>% filter(sort_digits %in% names(which.max(table(sort_digits))))

rf = intersect(r1$Country, r2$Country)

rf == test
# [1] TRUE


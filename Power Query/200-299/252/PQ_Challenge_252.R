library(tidyverse)
library(readxl)
library(janitor)

path = "Power Query/PQ_Challenge_252.xlsx"
input = read_excel(path, range = "A1:D17")
test  = read_excel(path, range = "F1:J11")
r1 = input %>%
  mutate(group = consecutive_id(nchar(`Store No`) == 1)) %>%
  split(.$group) %>%
  map(~ {
    if (.x$group[1] %% 2 == 0) {
      colnames(.x) <- .x[1, ]
      .x <- .x[-1, ]
    }
    .x
  })

r2 = r1 %>%
  keep(~ nrow(.x) == 1) %>%
  reduce(bind_rows) %>%
  remove_empty("cols")

r3 = r1 %>%
  keep(~ nrow(.x) > 1) %>%
  map(~ .x %>%
    remove_empty("cols") %>%
    clean_names()) %>%
  reduce(bind_rows) %>%
  mutate(group = coalesce(x2, x4, x6) - 1,
         first_visit_date = as.POSIXct(excel_numeric_to_date(as.numeric(first_visit_date))),
         last_purchase_date = as.POSIXct(excel_numeric_to_date(as.numeric(last_purchase_date)))) %>%
  select(-starts_with("x"))

result = r2 %>%
  left_join(r3, by = "group") %>%
  select(-group)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
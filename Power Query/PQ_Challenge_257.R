library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_257.xlsx"
input = read_excel(path, range = "A1:B18")
test  = read_excel(path, range = "D1:I9")

result = input %>%
  mutate(group = cumsum(is.na(Quantity)) + 1) %>%
  na.omit() %>%
  mutate(rn = row_number(), .by = group) %>%
  pivot_wider(names_from = rn, values_from = c(Quantity, Birds))

process_result <- function(data, col_prefix) {
  process_data <- function(data, col_prefix) {
    data %>%
      select(-starts_with(col_prefix)) %>%
      set_names(colnames(test)) %>%
      mutate(across(everything(), as.character))
  }
  process_data(data, col_prefix)
}

output <- bind_rows(
  process_result(result, "Quantity"),
  process_result(result, "Birds")
) %>%
  arrange(Column1) %>%
  mutate(Column1 = ifelse(row_number() %% 2 == 0, "Quantity", "Birds"))

all.equal(output, test, check.attributes = FALSE)
#> [1] TRUE
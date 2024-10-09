library(tidyverse)
library(readxl)

path = "Excel/561 Maximum Profit.xlsx"

input = read_excel(path, range = "A2:J11")
test  = read_excel(path, range = "K2:M11") %>%
  mutate(across(everything(), ~if_else(.x == "NP", NA_real_, as.numeric(.x))))

process_row <- function(...){
  row <- c_across(everything())
  cell_list <- map(1:length(row), ~row[.x:length(row)])
  df_pairs <- map_dfr(1:length(cell_list), function(i) {
    tibble(
      from = rep(row[i], length(cell_list[[i]]) - 1),
      to = cell_list[[i]][-1]
    )
  })
  df_pairs <- df_pairs %>%
    mutate(diff = to - from)
  max_pair <- df_pairs %>%
    slice_max(diff, with_ties = FALSE)
  return(list(
    max_diff = max_pair$diff,
    from_value = max_pair$from,
    to_value = max_pair$to
  ))
}

result <- input %>%
  rowwise() %>%
  mutate(result = list(process_row(across(everything())))) %>%
  mutate(
    Buy = result$from_value,
    Sell = result$to_value,
    Profit = result$max_diff
  ) %>%
  ungroup() %>%
  select(Buy, Sell, Profit) %>%
  mutate(across(everything(), ~if_else(Profit <= 0, NA_real_, .x)))
  

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE

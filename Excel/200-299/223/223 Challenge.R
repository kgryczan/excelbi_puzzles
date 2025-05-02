library(tidyverse)
library(readxl)

path = "Excel/223 Sort First Elements.xlsx"
input = read_excel(path, range = "A1:I11")
test  = read_excel(path, range = "K2:R11", col_names = FALSE)

# write function that is sorting rows elements but only n where n is in 9th column

sort_row = function(row, n) {
  # sort the first n elements of the row
  sorted_row = sort(row[1:n])
  # return the sorted row with the rest of the elements unchanged
  return(c(sorted_row, row[(n+1):length(row)]))
}

# apply the function to each row of the input data frame
sorted_input = input %>%
  rowwise() %>%
  mutate(sorted_row = list(sort_row(c_across(1:8), `Sort Key`))) %>%
  unnest_wider(sorted_row, names_sep = "_") %>%
  select(starts_with("sorted_row_")) %>%
  select(1:8)

all.equal(sorted_input, test, check.attributes = FALSE) 
# [1] TRUE
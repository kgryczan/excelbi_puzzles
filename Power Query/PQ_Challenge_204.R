library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_204.xlsx"
input = read_excel(path, range = "A1:D7")
test = read_excel(path, range = "F1:I4")

count_intersections <- function(col_name, df) {
  col = df[[col_name]] %>% na.omit()
  other_cols = df %>% select(-all_of(col_name)) %>% map(na.omit)
  
  intersection_counts = other_cols %>%
    map_int(~ length(intersect(col, .x)))
  
  filtered_counts = intersection_counts[intersection_counts > 0]
  filtered_names = names(filtered_counts)
  
  map2_chr(filtered_names, filtered_counts, ~ paste(.x, "-", .y)) %>%
    paste(collapse = ", ")
}

result = map_chr(names(input), ~ count_intersections(.x, input))

result1 = tibble(
  Column = paste(names(input), "Match"),
  Intersections = result
) %>%
  separate_rows(Intersections, sep = ", ") %>%
  mutate(nr = row_number(), .by = Column) %>%
  pivot_wider(names_from = Column, values_from = Intersections) %>%
  select(-nr)

identical(result1, test)
# [1] TRUE
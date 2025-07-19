library(tidyverse)
library(readxl)

input = read_excel("Crossword Type Numbering.xlsx", range = "A2:J9", col_names = c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J"))
test = read_excel("Crossword Type Numbering.xlsx", range = "A13:J20", col_names = c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J"))

fill_sequential = function(df) {
  df_long = df %>%
    rowid_to_column() %>%
    pivot_longer(cols = -rowid, names_to = "col", values_to = "value")
  
  position_to_fill = which(is.na(df_long$value))
  
  df_long$value[position_to_fill] = as.character(1:length(position_to_fill))
  
  df_filled = df_long %>%
    pivot_wider(names_from = "col", values_from = "value") %>%
    select(-rowid)
  
  return(df_filled)
}
result = fill_sequential(input)
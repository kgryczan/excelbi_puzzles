library(readxl)
library(tidyverse)

input = read_excel("Excel/477 Records Split and Alignment.xlsx", range = "A2:B15")
test  = read_excel("Excel/477 Records Split and Alignment.xlsx", range = "D2:M6") 
names(test) = gsub("\\.+\\d+", "", names(test))

nr = nrow(input)

seq = 1
i = 1
while(sum(seq) <= nr){ 
  seq = c(seq, i)
  i = i + 1
}
seq = seq[-1]

slice_dataframe <- function(df, seq) {
  indices <- map2(c(0, cumsum(seq)[-length(seq)]), cumsum(seq), ~(.x + 1):.y)
  map(indices, ~df[.x, ])
}

indexed_input = slice_dataframe(input, seq)

pad_and_bind_dataframes <- function(dfs) {
  max_length <- max(map_int(dfs, nrow))
  pad_df <- function(df, length) {
    if (nrow(df) < length) {
      additional_rows <- tibble(x = rep(NA, length - nrow(df)))
      df <- bind_rows(df, additional_rows)
    }
    df
  }
  padded_dfs <- map(dfs, pad_df, length = max_length)
  bound_df <- bind_cols(padded_dfs) %>%
    select(-starts_with("x")) 

  bound_df <- bound_df %>% filter_all(any_vars(!is.na(.)))
  
  bound_df
}

result = pad_and_bind_dataframes(indexed_input)
names(result) = gsub("\\.+\\d+", "", names(result))

all.equal(result, test)

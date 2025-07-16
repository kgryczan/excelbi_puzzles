library(tidyverse)

initial_value <- 10

generate_sentence <- function(x, initial_value) {
  if (x <= initial_value & x > 2) {
    first_row = paste("I got", x, "oranges, put all", x, "in bag")
    second_row = paste("I ate 1 orange,", x-1, "are remaining.")
    res = tribble(~sentence, first_row, second_row)
    return(res)
  } else if (x == 2) {
    first_row = paste("I got", x, "oranges, put all", x, "in bag")
    second_row = paste("I ate 1 orange,", x-1, "is remaining.")
    res = tribble(~sentence, first_row, second_row)
    return(res)
  } else if (x == 1) {
    first_row = paste("I got", x, "orange, put all", x, "in bag")
    second_row = paste("I ate 1 orange, None are remaining.")
    res = tribble(~sentence, first_row, second_row)
    return(res)
  }
}

# Use purrr::map_chr to generate sentences
sentences <- map_dfr(initial_value:0, ~ generate_sentence(.x, initial_value)) 
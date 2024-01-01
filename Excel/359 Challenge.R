library(tidyverse)
library(readxl)

input = read_excel("Excel/359 Express as Sum of Consecutive Digits.xlsx", range = "A1:A10")
test  = read_excel("Excel/359 Express as Sum of Consecutive Digits.xlsx", range = "B1:B10") %>%
  mutate(`Answer Expected` = str_remove_all(as.character(`Answer Expected`), "\\s"))

find_consecutive_sums <- function(target) {
  results <- tibble()
  for (start_num in 1:(target/2 + 1)) {
    sum <- start_num
    next_num <- start_num
    while (sum < target) {
      next_num <- next_num + 1
      sum <- sum + next_num
      if (sum == target) {
        results <- bind_rows(results, tibble(start = start_num, end = next_num))
      }
    }
  }
  if (nrow(results) == 0) {
    return(tibble(Numbers = target, seq = NA_character_))
  } else {
    sqs <- results %>%
      mutate(
        Numbers = target,
        seq = map2_chr(start, end, ~paste(.x:.y, collapse = "+"))
      ) %>%
      select(Numbers, seq)
    return(sqs)
  }
  
}

result = map(input$Numbers, find_consecutive_sums) %>%
  bind_rows() %>%
  group_by(Numbers) %>%
  slice(1)  
  # If you omit last line you'll get all sequences for each number. There are some :)
  # Final solutions are the longest sequences, so we only keep the first one.

identical(result$seq, test$`Answer Expected`)
# [1] TRUE


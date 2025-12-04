library(tidyverse)
library(readxl)
library(purrr)
library(rlang)

path <- "Excel/800-899/862/862 Gijswijt's Sequence.xlsx"
excel_data <- read_excel(path, range = "H1:AX65")
sequence_vector <- as.vector(t(as.matrix(excel_data))) %>%
  na.omit() %>%
  as.integer()

find_repetition_length <- function(seq) {
  max_repeats <- 1
  n <- length(seq)
  for (block_size in seq_len(n)) {
    block <- tail(seq, block_size)
    num_blocks <- n %/% block_size
    if (num_blocks <= max_repeats) {
      return(max_repeats)
    }
    repeat_count <- 1
    repeat {
      start <- n - (repeat_count + 1) * block_size + 1
      end <- n - repeat_count * block_size
      if (start < 1) {
        break
      }
      if (!identical(seq[start:end], block)) {
        break
      }
      repeat_count <- repeat_count + 1
    }
    max_repeats <- max(max_repeats, repeat_count)
  }
  max_repeats
}

generate_until_four <- function() {
  sequence <- list(1)
  repeat {
    next_number <- find_repetition_length(unlist(sequence))
    sequence <- append(sequence, next_number)
    if (next_number == 4) break
  }
  unlist(sequence)
}

result = generate_until_four()

all.equal(result, sequence_vector)

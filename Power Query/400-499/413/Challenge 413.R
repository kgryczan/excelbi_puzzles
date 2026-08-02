library(tidyverse)
library(readxl)

p <- "400-499/413/PQ_Challenge_413.xlsx"
data <- read_excel(p, range = "A1:C25")
expected <- read_excel(p, range = "E1:G9")

find_loops <- function(d) {
  to <- setNames(d$Preference, d$Guest)
  order <- setNames(seq_along(to), names(to))
  cycle <- function(path) {
    nxt <- to[[last(path)]]
    if (nxt %in% path) {
      path[match(nxt, path):length(path)]
    } else {
      cycle(c(path, nxt))
    }
  }
  normalize <- function(loop) {
    i <- which.min(order[loop])
    c(loop[i:length(loop)], loop[seq_len(i - 1)])
  }
  loops <- names(to) %>%
    map(~ normalize(cycle(.x))) %>%
    map_chr(paste, collapse = " > ") %>%
    unique()
  tibble(
    Table = d$Table[1],
    LoopID = paste0(d$Table[1], seq_along(loops)),
    `Seating Order` = loops
  )
}

result <- data %>% group_split(Table) %>% map_dfr(find_loops)
print(all.equal(result, expected))

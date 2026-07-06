library(tidyverse)
library(readxl)

path <- "1000-1099/1014/1014 - Tokens Sorting.xlsx"
input <- read_excel(path, range = "A1:A10")
test <- read_excel(path, range = "B1:B10")

result <- input %>%
  mutate(
    Output = map_chr(Data, \(x) {
      runs <- rle(str_split_1(x, ""))

      tibble(
        char = runs$values,
        len = runs$lengths,
        pos = seq_along(char)
      ) %>%
        arrange(desc(len), pos) %>%
        transmute(token = str_c(char, len)) %>%
        pull(token) %>%
        str_c(collapse = "-")
    })
  )

all.equal(result$Output, test$Output)
# True

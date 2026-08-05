library(tidyverse)
library(readxl)

path <- "1000-1099/1036/1036 Max Zig Zag Length.xlsx"
input <- read_excel(path, range = "A1:A21")
test <- read_excel(path, range = "A1:B21")

max_zigzag <- function(text) {
  numbers <- str_split(text, ", ")[[1]] %>% as.numeric()
  signs <- sign(diff(numbers))

  reduce(
    signs,
    function(state, sign) {
      current <- if (!sign) {
        1
      } else if (state[2] && sign != state[2]) {
        state[1] + 1
      } else {
        2
      }
      c(current, sign, max(state[3], current))
    },
    .init = c(1, 0, 1)
  )[3]
}

result <- input %>%
  mutate(answer = map_dbl(Data, max_zigzag)) %>%
  rename(`Answer Expected` = answer)

all.equal(result, test)

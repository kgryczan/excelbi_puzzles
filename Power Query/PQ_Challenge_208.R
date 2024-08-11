library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_208.xlsx"
input = read_xlsx(path, range = "A1:C35")

find_defects <- function(input) {
  generate_integer_set_with_mean <- function(target_mean) {
    x1 <- sample(1:(2 * target_mean), 1)
    x2 <- sample(1:(2 * target_mean), 1)
    x3 <- 3 * target_mean - x1 - x2
    
    while (x3 <= 0 || x3 > 2 * target_mean) {
      x1 <- sample(1:(2 * target_mean), 1)
      x2 <- sample(1:(2 * target_mean), 1)
      x3 <- 3 * target_mean - x1 - x2
    }
    return(c(x1, x2, x3))
  }
  initial_set = generate_integer_set_with_mean(input$`3 Year MV`[which(!is.na(input$`3 Year MV`))[1]])
  res = input %>%
    mutate(defects = NA) %>%
    slice(1:3) %>%
    mutate(defects = initial_set) %>%
    bind_rows(input %>% slice(4:n()))
  for (i in 4:nrow(res) - 1) {
    res$defects[i] = 3 * res$`3 Year MV`[i + 1] - res$defects[i - 2] - res$defects[i - 1]
  }
  return(res)
}

result = input %>%
  split(.$Month) %>%
  map(find_defects) %>%
  bind_rows()

print(result)

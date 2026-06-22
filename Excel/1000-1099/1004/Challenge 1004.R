library(tidyverse)
library(readxl)

path <- "1000-1099/1004/1004 Repititions.xlsx"
input <- read_excel(path, range = "A1:A20")
test <- read_excel(path, range = "B1:B20")

xpand <- function(x) {
  if (is.na(x)) {
    return(NA_character_)
  }
  while (str_detect(x, "\\(")) {
    x <- str_replace(x, "\\d*\\([^()]*\\)", \(m) {
      p <- str_match(m, "^(\\d*)\\(([^()]*)\\)$")
      str_dup(p[3], if_else(p[2] == "", 1L, as.integer(p[2])))
    })
  }
  x
}

result = input %>%
  mutate(expanded = map_chr(Expression, xpand))
all.equal(result$expanded, test$`Answer Expected`)
# [1] TRUE

library(tidyverse)
library(readxl)

p <- "1000-1099/1033/1033 Extract Third Segment.xlsx"
data <- read_excel(p, range = "A1:B21")

third_segment <- function(text) {
  chars <- str_split(coalesce(text, ""), "", simplify = TRUE)[1, ]
  if (!length(chars)) {
    return("")
  }
  depth <- cumsum(chars == "<") - cumsum(chars == ">")
  cuts <- which(chars == "," & depth == 0 & lead(chars, default = "") != " ")
  starts <- c(1, cuts + 1)
  ends <- c(cuts - 1, length(chars))
  if (length(starts) < 3 || starts[3] > ends[3]) {
    NA_character_
  } else {
    paste0(chars[starts[3]:ends[3]], collapse = "")
  }
}

result <- data %>%
  mutate(Result = map_chr(Data, third_segment))
print(result)
print(all.equal(result$Result, data$`Answer Expected`))

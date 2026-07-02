library(tidyverse)
library(readxl)

path <- "1000-1099/1012/1012 Vowel Replacement by Index.xlsx"
input <- read_excel(path, range = "A1:A11")
test <- read_excel(path, range = "B1:B11")

vowels <- c("a", "e", "i", "o", "u", "A", "E", "I", "O", "U")

result <- input %>%
  mutate(letters = str_split(Data, "")) %>%
  unnest(letters) %>%
  mutate(
    index = (cumsum(letters %in% vowels) - 1) %% 5 + 1,
    replaced = if_else(
      letters %in% vowels,
      if_else(
        str_detect(letters, "[A-Z]"),
        c("A", "E", "I", "O", "U")[index],
        c("a", "e", "i", "o", "u")[index]
      ),
      letters
    ),
    .by = Data
  ) %>%
  summarise(result = paste(replaced, collapse = ""), .by = Data)

all.equal(result$result, test$`Answer Expected`)
# True

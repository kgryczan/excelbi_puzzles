library(tidyverse)
library(readxl)

path <- "1000-1099/1017/1017 Typographical Changes.xlsx"
input <- read_excel(path, range = "A1:A20")
dictionary <- read_excel(path, range = "C1:D36")
test <- read_excel(path, range = "F1:F20")

minor <- dictionary %>%
  filter(WordType == "Minor") %>%
  pull(Word) %>%
  str_to_lower()

acronyms <- dictionary %>%
  filter(WordType == "Acronym") %>%
  pull(Word) %>%
  str_to_lower()

fix_word <- \(x, force_cap = FALSE) {
  punct <- str_extract(x, "[,:.!?]+$") %>% replace_na("")
  word <- str_remove(x, "[,:.!?]+$")

  bracketed <- str_detect(word, "^\\[.+\\]$")
  core <- word %>% str_remove("^\\[") %>% str_remove("\\]$")
  key <- str_to_lower(core)

  out <- case_when(
    bracketed ~ str_to_upper(core),
    key %in% acronyms ~ str_to_upper(core),
    key %in% minor & !force_cap ~ str_to_lower(core),
    TRUE ~ str_to_title(str_to_lower(core))
  )

  str_c(if_else(bracketed, str_c("[", out, "]"), out), punct)
}

title_fix <- \(x) {
  words <- str_split_1(x, "\\s+")

  map2_chr(
    words,
    seq_along(words) == 1 | lag(str_detect(words, ":$"), default = FALSE),
    fix_word
  ) %>%
    str_c(collapse = " ")
}

result <- input %>%
  mutate(Output = map_chr(Data, title_fix))

all.equal(result$Output, test$`Answer Expected`)
# inconsistent usage of bracket rule

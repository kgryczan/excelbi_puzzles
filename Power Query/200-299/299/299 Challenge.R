library(tidyverse)
library(readxl)
library(arrangements)

path = "Power Query/200-299/299/PQ_Challenge_299.xlsx"
input1 = read_excel(path, range = "A1:A2")
input2 = read_excel(path, range = "A4:A8")
test  = read_excel(path, range = "C1:D24") 

sent = input1 %>%
  separate_rows(Paragraph, sep = "(?<=\\.)\\s") 

sentences = sent$Paragraph

get_combos = function(k) {
  combn(sentences, k, simplify = FALSE) %>%
    map_chr(~ paste(sort(.x), collapse = " "))
}

all_combos = map_dfr(1:length(sentences), ~ tibble(
  size = .x,
  combination = get_combos(.x)
)) %>%
  mutate(n_alpha = str_count(combination, "[a-zA-Z]"))

range = input2 %>%
  separate_wider_delim(`From - To`, delim = "-", names =c("min", "max"), cols_remove = F) %>%
  mutate(across(c(min, max), as.integer))

result = all_combos %>%
  left_join(range, by = character()) %>%
  filter(n_alpha >= min & n_alpha <= max) %>%
  select(`From - To`, Sentences = combination) %>%
  arrange(Sentences)

test2 = test %>%
  mutate(rn = row_number()) %>%
  separate_rows(Sentences, sep = "(?<=\\.)\\s") %>%
  summarise(Sentences = paste(sort(Sentences), collapse = " "), 
            `From - To` = unique(`From - To`),
            .by = rn) %>%
  arrange(Sentences) %>%
  select(-rn)

all.equal(result$Sentences, test2$Sentences, check.attributes = FALSE)
# > [1] TRUE
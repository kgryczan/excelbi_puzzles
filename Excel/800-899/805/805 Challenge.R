library(tidyverse)
library(readxl)

path = "Excel/800-899/805/805 Vowels in Increasing or Decreasing Order.xlsx"
input = read_excel(path, range = "A2:B16")
test  = read_excel(path, range = "D2:G5")

vowel_factor = factor(c("a", "e", "i", "o", "u"),
                      levels = c("a", "e", "i", "o", "u"),
                      ordered = TRUE)

result = input %>%
  mutate(
    vowels = str_extract_all(str_to_lower(Rivers), "[aeiou]"),
    ord = map_chr(vowels, ~ {
      d = diff(match(.x, levels(vowel_factor)))
      if (all(d >= 0) & any(d > 0)) "increasing"
      else if (all(d <= 0) & any(d < 0)) "decreasing"
      else "neither"
    })
  ) %>%
  filter(ord != "neither") %>%
  select(Group, Rivers) %>%
  arrange(Group, Rivers) %>%
  mutate(rn = row_number(), .by = Group) %>%
  pivot_wider(names_from = rn, names_glue = "River{rn}" , values_from = Rivers)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
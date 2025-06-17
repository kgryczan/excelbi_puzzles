library(tidyverse)
library(readxl)

path = "Excel/700-799/739/739 Count Vowels in All Substrings.xlsx"
input = read_excel(path, range = "A1:A10")
test = read_excel(path, range = "B1:B10")

result = input %>%
  mutate(
    substrings = map_chr(
      String,
      ~ {
        n <- nchar(.x)
        substrings <- flatten_chr(
          map(1:n, function(i) {
            map_chr(1:(n - i + 1), function(j) substr(.x, j, j + i - 1))
          })
        )
        paste(substrings, collapse = ", ")
      }
    )
  ) %>%
  separate_longer_delim(substrings, delim = ", ") %>%
  mutate(vowel_count = str_count(substrings, "[aeiouAEIOU]")) %>%
  summarise(total_vowel_count = sum(vowel_count), .by = String) %>%
  select(`Answer Expected` = total_vowel_count)

all.equal(result, test, check.attributes = FALSE)

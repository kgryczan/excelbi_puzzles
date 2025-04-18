library(tidyverse)
library(readxl)

path = "Excel/232 Affine Cipher.xlsx"
input = read_excel(path, range = "A1:C7")
test = read_excel(path, range = "D1:D7")

mapping = data.frame(letter = letters, number = 0:25)

result = input %>%
  separate_rows(Text, sep = "") %>%
  filter(Text != "") %>%
  mutate(
    Capital = ifelse(str_detect(Text, "[A-Z]"), 1, 0),
    text_low = str_to_lower(Text),
    text_value = match(text_low, mapping$letter) - 1,
    decoded_value = (a * text_value + b) %% 26,
    decoded_letter = mapping$letter[decoded_value + 1],
    decoded_text = ifelse(
      Capital == 1,
      str_to_upper(decoded_letter),
      decoded_letter
    )
  ) %>%
  replace_na(list(decoded_text = " ")) %>%
  summarise(
    Text = paste(Text, collapse = ""),
    decoded_text = paste(decoded_text, collapse = ""),
    .by = c(a, b)
  )

all.equal(result$decoded_text, test$`Expected Answer`)
#> [1] TRUE

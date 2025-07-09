library(tidyverse)
library(readxl)

path = "Excel/200-299/253/253 Gaderypoluki Cipher Missing Keys.xlsx"
input = read_excel(path, range = "A1:C6")
test  = read_excel(path, range = "D1:D6")

result = input %>%
  rowwise() %>%
  mutate(Text_list = str_split(str_to_upper(Text), ""),
         Encrypted_list = str_split(str_to_upper(`Encrypted Text`), "")) %>%
  mutate(Nested_df = list(tibble(Text_a = Text_list, Encrypted_a = Encrypted_list))) %>%
  ungroup() %>%
  mutate(Nested_df = map(Nested_df, ~ filter(.x, Text_a != Encrypted_a))) %>%
  unnest(Nested_df) %>%
  distinct() %>%
  unite("miss_key", c(Text_a, Encrypted_a), sep = "") %>%
  filter(!str_detect(Key, miss_key)) %>%
  summarise(miss_key = list(miss_key), .by = c("Text", "Key", "Encrypted Text")) %>%
  mutate(
    Key_final = map2_chr(
      Key, miss_key,
      ~{parts <- str_split(.x, "-", simplify = TRUE)
        parts[parts == "**"] <- .y
        str_c(parts, collapse = "-")}))

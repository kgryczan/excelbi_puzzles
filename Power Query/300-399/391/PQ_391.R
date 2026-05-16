library(tidyverse)
library(readxl)

path <- "300-399/391/PQ_Challenge_391.xlsx"
input1 <- read_excel(path, range = "A1:B29")
input2 <- read_excel(path, range = "D1:E7")
test <- read_excel(path, range = "D12:E20")

i1 = input1 %>%
  summarise(Items = paste0(Item_Code, collapse = ", "), .by = Order_ID) %>%
  cross_join(input2) %>%
  mutate(
    Match = str_detect(Items, Items_Needed),
    No_items = str_count(Items_Needed, "P-")
  ) %>%
  arrange(desc(No_items), Promo_Name) %>%
  mutate(
    Applied_Promo = ifelse(
      max(Match) == FALSE,
      "No Promo",
      first(Promo_Name[Match == TRUE])
    ),
    .by = Order_ID
  ) %>%
  select(Order_ID, Applied_Promo) %>%
  distinct()

all.equal(i1, test)
## [1] TRUE

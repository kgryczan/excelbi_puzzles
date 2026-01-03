library(tidyverse)
library(readxl)

path <- "Power Query/300-399/353/PQ_Challenge_353.xlsx"
input1 <- read_excel(path, range = "A1:E51")
input2 <- read_excel(path, range = "G1:H5")
test <- read_excel(path, range = "G9:H14")

result <- input1 %>%
  left_join(input2, by = "Region") %>%
  mutate(
    capped = pmin(`2024 Gross` * .05, `Max Bonus Cap`),
    prosperity_tax = case_when(
      capped < 2000 ~ 0,
      capped <= 3500 ~ (capped - 2000) * 0.10,
      TRUE ~ 150 + (capped - 3500) * .2
    ),
    total = capped - prosperity_tax + if_else(Dept == "Sales", 300, 0)
  ) %>%
  summarise(Bonus = sum(total, na.rm = TRUE), .by = Region) %>%
  arrange(Region) %>%
  janitor::adorn_totals("row", name = "Total")

all.equal(result, test, check.attributes = F)

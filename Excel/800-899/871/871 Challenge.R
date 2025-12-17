library(tidyverse)
library(readxl)

path <- "Excel/800-899/871/871 Ranking of Hockey Winners Decade-wise.xlsx"
input <- read_excel(path, range = "A2:D90")
test <- read_excel(path, range = "F2:I13")

result <- input %>%
  pivot_longer(-Year, names_to = "Medal", values_to = "Country") %>%
  mutate(
    Decade = paste0((Year %/% 10) * 10, "-", (Year %/% 10) * 10 + 9),
    Medal_value = recode(Medal, Gold = 3, Silver = 2, Bronze = 1)
  ) %>%
  summarise(Total = sum(Medal_value), .by = c(Decade, Country)) %>%
  mutate(rank = dense_rank(-Total), .by = Decade) %>%
  filter(rank <= 3) %>%
  arrange(Decade, rank, Country) %>%
  summarise(
    Country = paste(Country, collapse = ", "),
    .by = c(Decade, rank)
  ) %>%
  pivot_wider(
    names_from = rank,
    values_from = Country,
    names_prefix = "Rank"
  ) %>%
  select(Decade, everything())

all.equal(result, test)

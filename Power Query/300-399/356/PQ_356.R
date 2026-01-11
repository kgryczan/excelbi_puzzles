library(tidyverse)
library(readxl)

path <- "Power Query/300-399/356/PQ_Challenge_356.xlsx"
input <- read_excel(path, range = "A1:F51")
test <- read_excel(path, range = "I1:L51")

result = input %>%
  mutate(peer_avg = cummean(Price), .by = c(Region, Type, Beds)) %>%
  mutate(reg_avg = cummean(Price), .by = Region) %>%
  mutate(reg_hist_avg = lag(cummean(Price), default = 0), .by = Region) %>%
  mutate(
    prem_disc = ((Price - reg_hist_avg) * 100 / reg_hist_avg) %>% round(2),
    .by = Region
  ) %>%
  mutate(prem_disc = ifelse(is.infinite(prem_disc), 0, prem_disc)) %>%
  group_by(Type) %>%
  mutate(
    q25 = map_dbl(
      seq_along(Price),
      ~ if (.x == 1) {
        NA_real_
      } else {
        quantile(Price[1:(.x - 1)], .25, names = FALSE)
      }
    ),
    q75 = map_dbl(
      seq_along(Price),
      ~ if (.x == 1) {
        NA_real_
      } else {
        quantile(Price[1:(.x - 1)], .75, names = FALSE)
      }
    )
  ) %>%
  ungroup() %>%
  mutate(
    Tier = case_when(
      Price < q25 ~ "Entry",
      Price > q75 ~ "Luxury",
      TRUE ~ "Mid-Market"
    )
  ) %>%
  select(
    ID,
    `Specific Peer Avg` = peer_avg,
    `Premium / Discount %` = prem_disc,
    `Tier Status` = Tier
  )

all.equal(result, test)
# Not all cases correct.

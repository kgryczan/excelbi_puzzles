library(tidyverse)
library(readxl)

path <- "Excel/800-899/867/867 Longest Streak.xlsx"
input <- read_excel(path, range = "A1:G101")
test <- read_excel(path, range = "I1:J7")

result <- input %>%
  arrange(Rep, Year, Quarter) %>%
  complete(
    Rep,
    Year,
    Quarter = paste0("Q", 1:4),
    fill = list(Revenue = 0, Target = 0)
  ) %>%
  mutate(goal_achieved = Revenue >= Target) %>%
  group_by(Rep) %>%
  mutate(c = cumsum(goal_achieved != lag(goal_achieved, default = FALSE))) %>%
  summarise(
    longest_streak = max(rle(goal_achieved)$lengths[
      rle(goal_achieved)$values == TRUE
    ])
  ) %>%
  ungroup() %>%
  arrange(desc(longest_streak))

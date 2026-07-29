library(tidyverse)
library(readxl)

path <- "1000-1099/1030/1030 Player Transfer.xlsx"
input <- read_excel(path, range = "A2:C12") %>%
  setNames(c("from", "to", "amount"))
test <- read_excel(path, range = "E2:H7")

result <- bind_rows(
  input %>% transmute(Club = from, Earned = amount, Spent = 0),
  input %>% transmute(Club = to, Earned = 0, Spent = amount)
) %>%
  summarise(across(where(is.numeric), sum), .by = Club) %>%
  mutate(net_profit = Earned - Spent) %>%
  rename("Net Profit" = net_profit) %>%
  arrange(Club)

all.equal(result, test)
# TRUE

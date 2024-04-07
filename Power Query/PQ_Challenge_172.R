library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_172.xlsx", range = "A1:F10") %>% 
  janitor::clean_names()
test  = read_excel("Power Query/PQ_Challenge_172.xlsx", range = "H1:I6")

r1 = input %>%
  mutate(share_percent = ifelse(is.na(share_percent), "100", share_percent)) %>%
  separate_rows(share_percent, sep = ", ") %>%
  group_by(item) %>%
  mutate(nr = row_number(), 
         Agent = ifelse(nr == 1, agent1, agent2)) %>%
  ungroup() %>%
  mutate(Commission = amount * as.numeric(share_percent) / 100 * commission_percent / 100)

top = r1 %>%
  group_by(Agent) %>%
  summarise(Commission = sum(Commission) %>% round(0))

total = top %>%
  summarise(Commission = sum(Commission))

total$Agent = "Total"
result = select(total, Agent, Commission) %>%
  bind_rows(top) %>%
  arrange(Agent)

identical(result, test)
# [1] TRUE


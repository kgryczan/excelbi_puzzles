library(tidyverse)
library(readxl)

path <- "Power Query/300-399/361/PQ_Challenge_361.xlsx"
input <- read_excel(path, sheet = "Sheet1", range = "A1:A21")
test <- read_excel(path, sheet = "Sheet1", range = "C1:F6")

pattern <- "#(?<TicketID>\\d+-\\d+)#\\s*\\((?<Priority>[A-Z]+)\\)\\s*Service:(?<Service>[^>]+)\\s>>\\s*(?<Status>\\w+)"

result = input %>%
  mutate(`Log Data` = str_remove_all(`Log Data`, "Status:"))

result = str_match(result$`Log Data`, pattern) %>%
  as_tibble() %>%
  select(-V1) %>%
  filter(!Status %in% c("Resolved", "Closed"))

all.equal(result, test, check.attributes = FALSE)
# TRUE

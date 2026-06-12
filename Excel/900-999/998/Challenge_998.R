library(tidyverse)
library(readxl)

path <- "900-999/998/998 Extraction.xlsx"
input <- read_excel(path, range = "A2:B19")
test <- read_excel(path, range = "D2:G7")

result <- input %>%
  extract(
    RevisionLog,
    into = c("Configuration", "Revision", "Status"),
    regex = "\\{CFG:(.*)\\|REV:(\\d+)\\|STS:(.*)\\}",
    convert = TRUE
  ) %>%
  mutate(
    status_rank = case_match(
      Status,
      "FINAL" ~ 1,
      "REVIEW" ~ 2,
      .default = 3
    )
  ) %>%
  arrange(TicketID, status_rank, desc(Revision)) %>%
  slice_head(n = 1, by = TicketID) %>%
  select(TicketID, Configuration, Revision, Status)

all.equal(result, test)
# [1] TRUE

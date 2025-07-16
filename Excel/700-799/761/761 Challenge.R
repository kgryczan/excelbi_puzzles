library(tidyverse)
library(readxl)

path = "Excel/700-799/761/761 Open POs.xlsx"
input = read_excel(path, range = "A1:B11")
test  = read_excel(path, range = "D1:D7")

expand_po = function(df) {
  df %>%
    separate(PO, into = c("Min", "Max"), sep = "-", fill = "right") %>%
    mutate(PO = map2(as.numeric(Min), as.numeric(coalesce(Max, Min)), seq)) %>%
    select(Status, PO) %>%
    unnest(PO)
}

opens  = input  %>% filter(Status == "Open")   %>% expand_po()
closed = input  %>% filter(Status == "Closed") %>% expand_po()

still_open = opens %>%
  anti_join(closed, by = "PO") %>%
  group_by(grp = cumsum(c(1, diff(PO) > 1))) %>%
  summarise(`Answer Expected` = ifelse(n() == 1, as.character(min(PO)), paste0(min(PO), "-", max(PO))), .groups = "drop") %>%
  select(`Answer Expected`)

all.equal(still_open, test, check.attributes = FALSE)
#> [1] TRUE
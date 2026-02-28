library(tidyverse)
library(readxl)

path <- "Power Query/300-399/369/PQ_Challenge_369.xlsx"
input <- read_excel(path, range = "A1:A21", col_names = FALSE)
test <- read_excel(path, range = "C1:E4")

result <- input %>%
  separate_wider_delim(
    col = 1,
    delim = ",",
    names = c("HxId", "ParentId", "CreatedDate", "OldValue", "NewValue"),
    too_few = "align_start"
  ) %>%
  janitor::row_to_names(1) %>%
  mutate(
    CreatedDate = as.Date(CreatedDate),
    Status = coalesce(NewValue, OldValue)
  ) %>%
  arrange(ParentId, CreatedDate) %>%
  summarise(
    `Status Path` = str_c(Status, collapse = " > "),
    `Lifecycle Days` = as.integer(max(CreatedDate) - min(CreatedDate)),
    .by = ParentId
  )

all.equal(result, test)
#> [1] TRUE

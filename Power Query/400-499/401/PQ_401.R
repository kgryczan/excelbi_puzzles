library(tidyverse)
library(readxl)

path <- "400-499/401/PQ_Challenge_401.xlsx"
read_and_trim <- function(path, sheet, range) {
  read_excel(path, sheet = sheet, range = range) %>%
    rename_with(str_trim) %>%
    mutate(across(everything(), str_trim))
}
input <- read_and_trim(path, sheet = "Sheet1 (2)", range = "A1:D31")
test <- read_and_trim(path, sheet = "Sheet1 (2)", range = "F1:J17")

df_long <- input %>%
  transmute(
    AccountID,
    OwnerID,
    start_date = as.Date(StartDate),
    end_date = as.Date(EndDate)
  ) %>%
  mutate(Date = map2(start_date, end_date, seq, by = "day")) %>%
  unnest(Date) %>%
  select(AccountID, OwnerID, Date) %>%
  unnest(Date) %>%
  select(AccountID, OwnerID, Date) %>%
  na.omit() %>%
  mutate(wd_num = as.numeric(format(Date, "%u"))) %>%
  filter(wd_num %in% 1:5) %>%
  mutate(diff_d = as.numeric(Date - lag(Date)), .by = c(AccountID, OwnerID)) %>%
  mutate(
    consecutive_id = cumsum(
      is.na(diff_d) | (diff_d >= 0 & !diff_d %in% c(1, 3, 0))
    ),
    .by = c(AccountID, OwnerID)
  ) %>%
  mutate(cons_won = paste0(OwnerID, "_", consecutive_id)) %>%
  summarise(
    start_date = as.character(min(Date)),
    end_date = as.character(max(Date)),
    .by = c(AccountID, OwnerID, cons_won)
  ) %>%
  select(
    AccountID,
    EpisodeStart = start_date,
    EpisodeEnd = end_date,
    OwnerID
  ) %>%
  mutate(
    EpisodeNo = as.character(row_number()),
    .by = AccountID,
    .after = AccountID
  )

all.equal(df_long, test, check.attributes = FALSE)
# True

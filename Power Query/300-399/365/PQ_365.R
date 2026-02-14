library(tidyverse)
library(readxl)

path <- "Power Query/300-399/365/PQ_Challenge_365.xlsx"
input <- read_excel(path, range = "A1:A19")
test <- read_excel(path, range = "C1:F6")

x <- input %>%
  mutate(
    event = str_extract(Data, "^(START|DATA|END)"),
    proc = cumsum(event == "START" & lag(event, default = "END") == "END")
  ) %>%
  mutate(ok = any(Data == "END:Success"), .by = proc) %>%
  filter(ok) %>%
  mutate(ProcessID = dense_rank(proc))

starts <- x %>%
  filter(event == "START") %>%
  transmute(
    proc,
    ProcessID,
    idx = row_number(),
    .by = proc,
    User = str_match(Data, "User_([^:]+)")[, 2],
    Type = str_match(Data, "Type_([^:]+)")[, 2]
  )

datas <- x %>%
  filter(event == "DATA") %>%
  transmute(
    proc,
    idx = row_number(),
    .by = proc,
    Value = as.numeric(str_match(Data, "Value_(\\d+)")[, 2])
  )

result <- starts %>%
  left_join(datas, by = c("proc", "idx")) %>%
  select(ProcessID, User, Type, Value)

all.equal(result, test)
#> [1] TRUE

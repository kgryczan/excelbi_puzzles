library(tidyverse)
library(readxl)

path <- "900-999/928/928 Summarize Status Hours.xlsx"
input <- read_excel(path, range = "A2:A27")
test <- read_excel(path, range = "C2:D7")

result <- input %>%
  mutate(
    Status = str_extract(Data, "Completed|In-Progress|On-Hold|Pending"),
    Hours = str_extract(Data, "\\d{1,3}(?:\\.\\d+)?(?=\\D*$)") |> as.numeric()
  ) %>%
  summarise(`Total Hours` = sum(Hours), .by = Status) %>%
  arrange(desc(`Total Hours`)) %>%
  bind_rows(
    summarise(., Status = "Total", `Total Hours` = sum(`Total Hours`))
  )

all.equal(result, test)
#> [1] TRUE

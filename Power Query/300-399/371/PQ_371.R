library(tidyverse)
library(readxl)

path <- "300-399/371/PQ_Challenge_371.xlsx"
input <- read_excel(path, range = "A1:C21")
test <- read_excel(path, range = "E1:I7")

result = input %>%
  mutate(
    Occurence = cumsum(`Event Type` == "Status") %>% as.numeric(),
    Status = ifelse(`Event Type` == "Status", Value, NA)
  ) %>%
  fill(Occurence, Status) %>%
  filter(`Event Type` != "Status") %>%
  summarise(
    `Average Reading` = mean(as.numeric(Value), na.rm = TRUE),
    `Max Reading` = max(as.numeric(Value), na.rm = TRUE),
    `Min Reading` = min(as.numeric(Value), na.rm = TRUE),
    .by = c(Occurence, Status)
  )

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE

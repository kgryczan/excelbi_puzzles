library(tidyverse)
library(readxl)

path <- "900-999/939/939 Location Update.xlsx"
input <- read_excel(path, range = "A2:C22")
test  <- read_excel(path, range = "E2:G22")

result <- input |>
  group_by(Name) |>
  mutate(Location = Location[which.max(Date)]) |>
  ungroup()

all.equal(result, test)
# [1] TRUE

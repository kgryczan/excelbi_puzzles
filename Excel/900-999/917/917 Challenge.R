library(tidyverse)
library(readxl)

path <- "Excel/900-999/917/917 Extract and Vstack.xlsx"
input <- read_excel(path, range = "A2:E21")
test <- read_excel(path, range = "G2:K6")

result = input %>%
  group_by(`Case No`) %>%
  fill(everything(), .direction = "downup") %>%
  summarise(
    `Case No` = first(`Case No`),
    Company = first(Company),
    `Start Date` = min(`Start Date`),
    `Finish Date` = max(`Finish Date`),
    Contact = last(Contact),
    .groups = "drop"
  )

all.equal(result, test)
## [1] TRUE

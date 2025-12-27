library(tidyverse)
library(readxl)

path <- "Power Query/300-399/351/PQ_Challenge_351.xlsx"
input1 <- read_excel(path, range = "A1:F21")
input2 <- read_excel(path, range = "H1:I6")
test <- read_excel(path, range = "H12:J17")

result = input1 %>%
  summarise(
    Sales = sum(Sales),
    `Annual Target` = first(`Annual Target`),
    .by = c(ID, Name, Department)
  ) %>%
  left_join(input2, by = c("Department")) %>%
  mutate(
    `Annual Bonus` = ifelse(
      (Sales - `Annual Target`) > 0,
      (Sales - `Annual Target`) * `Base Bonus Rate`,
      0
    )
  ) %>%
  select(ID, Name, `Annual Bonus`)

all.equal(result, test)

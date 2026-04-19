library(tidyverse)
library(readxl)
library(lubridate)

path <- "300-399/384/PQ_Challenge_384.xlsx"
input <- read_excel(path, range = "A1:C21")
test <- read_excel(path, range = "F1:H66")

calendar = expand.grid(
  Date = seq(
    as.Date(min(input$`Update Date`, na.rm = TRUE)),
    as.Date(max(input$`Update Date`, na.rm = TRUE)),
    by = "days"
  ),
  Product = unique(input$Product)
)

result = calendar %>%
  left_join(input, by = c("Date" = "Update Date", "Product")) %>%
  arrange(Product, Date) %>%
  group_by(Product) %>%
  mutate(update_flag = !is.na(`Confirmed Price`)) %>%
  fill(`Confirmed Price`, .direction = "down") %>%
  mutate(grp = cumsum(update_flag)) %>%
  group_by(Product, grp) %>%
  mutate(
    day = row_number(),
    base = first(`Confirmed Price`),
    decay = pmax(day - 5, 0),
    `Adjusted Price` = pmax(base * (1 - 0.1 * decay), 0)
  ) %>%
  ungroup() %>%
  select(Product, Date, `Adjusted Price`)

all.equal(result, test)
# [1] TRUE

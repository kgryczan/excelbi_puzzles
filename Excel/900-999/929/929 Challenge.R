library(tidyverse)
library(readxl)

path <- "900-999/929/929 Delivered Shipments.xlsx"
input <- read_excel(path, range = "A2:A22")
test <- read_excel(path, range = "C2:E7")

result = input %>%
  separate_wider_delim(
    Data,
    delim = "_",
    names = c("Date", "TruckID", "Status", "Revenue")
  ) %>%
  mutate(Revenue = parse_number(Revenue)) %>%
  filter(Status == "DELIVERED") %>%
  summarise(
    `Total Revenue` = paste0(
      "$",
      formatC(sum(Revenue), format = "f", digits = 2, big.mark = ",")
    ),
    `Last_Delivery_Date` = max(as.Date(Date)) %>% as.POSIXct(),
    .by = TruckID
  ) %>%
  arrange(parse_number(TruckID)) %>%
  select(TruckID, `Total Revenue`, `Last_Delivery_Date`)

all.equal(result, test, check.attributes = FALSE)
# > True

library(tidyverse)
library(readxl)

path <- "400-499/417/PQ_Challenge_417.xlsx"
input <- read_excel(path, range = "A1:D26")
test <- read_excel(path, range = "F1:L6")

result <- input %>%
  pivot_wider(
    id_cols = "CustomerID",
    names_from = "Event",
    values_from = "Amount",
    values_fn = sum,
    values_fill = 0
  ) %>%
  mutate(NetInvoiced = Invoice - Credit) %>%
  mutate(
    Outstanding = NetInvoiced - Payment,
    Unbilled = Contract - NetInvoiced
  ) %>%
  mutate(
    Status = case_when(
      NetInvoiced == Contract & Outstanding == 0 ~ "Closed",
      NetInvoiced > Contract ~ "Overbilled",
      Payment > NetInvoiced ~ "Overpaid",
      NetInvoiced < Contract ~ "Partially Billed",
      NetInvoiced == Contract & Outstanding != 0 ~ "Outstanding"
    )
  ) %>%
  select(
    CustomerID,
    ContractAmount = Contract,
    NetInvoiced,
    TotalPaid = Payment,
    Outstanding,
    Unbilled,
    Status
  )

all.equal(test, result)
# True

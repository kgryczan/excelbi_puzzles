library(tidyverse)
library(readxl)

path = "Excel/503 Payments Calculations.xlsx"
input1 = read_excel(path, range = "A1:B9")
input2 = read_excel(path, range = "D1:D9") %>% pull()
test = read_excel(path, range = "F1:L9")
colnames(test)[1] = "Customer"

result = input1 %>%
  separate_rows(`Purchase product (Tax not included)`, sep = ", ") %>%
  separate(`Purchase product (Tax not included)`, into = c("Product","Amount"), sep = ": ") %>%
  mutate(Amount = str_remove_all(Amount, ",") %>% as.numeric(),
         amount_with_tax = ifelse(Product %in% input2, Amount, Amount * 1.1)) %>%
  summarise(SUM = sum(Amount),
            AVERAGE = mean(Amount),
            MAX = max(Amount),
            MIN = min(Amount),
            COUNT = n() %>% as.numeric(),
            Payment = sum(amount_with_tax),
            .by = Customer)

all.equal(result, test)
# Column Payment has wrong value in test data
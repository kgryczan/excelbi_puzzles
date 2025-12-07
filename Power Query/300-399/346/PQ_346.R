library(tidyverse)
library(readxl)

path <- "Power Query/300-399/346/PQ_Challenge_346.xlsx"
input1 <- read_excel(path, range = "A1:F11")
input2 <- read_excel(path, range = "A14:G26")
test <- read_excel(path, range = "I1:S11")

result = input1 %>%
  mutate(
    Cust_Code = str_replace_all(Cust_Code, "[./_]", "-") %>%
      str_replace(., "CUST-", "")
  ) %>%
  left_join(
    input2 %>%
      filter(Record_Type == "CUSTOMER") %>%
      select(ID_Code, Name, Contact, Region),
    by = c("Cust_Code" = "ID_Code")
  ) %>%
  left_join(
    input2 %>%
      filter(Record_Type == "PRODUCT") %>%
      select(ID_Code, Name, Category, Unit_Price),
    by = c("Product_SKU" = "ID_Code")
  ) %>%
  select(
    Order_ID,
    Order_Date,
    Customer_Name = Name.x,
    Customer_Contact = Contact,
    Customer_Region = Region,
    Product_Name = Name.y,
    Product_Category = Category,
    Quantity = Qty,
    Unit_Price,
    Order_Status = Status
  ) %>%
  mutate(Order_Value = Quantity * Unit_Price, .after = Unit_Price)

all.equal(result, test)
# TRUE

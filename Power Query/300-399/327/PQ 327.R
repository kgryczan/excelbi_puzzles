library(tidyverse)
library(readxl)
library(janitor)

path <- "Power Query/300-399/327/PQ_Challenge_327.xlsx"
input <- read_excel(path, range = "A2:E21", col_names = FALSE) 
test  <- read_excel(path, range = "G2:H7")

input <- input %>% filter(`...1` != "Shipment Month")
header_rows <- which(grepl("Date", input$`...1`))
end_rows <- c(header_rows[-1] - 1, nrow(input))
sections <- map2(header_rows, end_rows, ~ input[.x:.y, ] %>% row_to_names(1))
sections <- map(sections, ~ t(.) %>% as_tibble(rownames = "Product"))
sections <- map(sections, ~ filter(.x, Product != "Date"))
sections <- map_dfr(sections, ~ pivot_longer(.x, -Product, names_to = "Date", values_to = "Sales"))
result <- sections %>% summarise(Amount <- sum(as.numeric(Sales), na.rm = T), .by = Product) %>%
  arrange(desc(Amount)) %>%
  rename(Vegetables <- Product)

all.equal(result, test)

library(tidyverse)
library(readxl)

path <- "1000-1099/1024/1024 Applying Promotions.xlsx"
input <- read_excel(path, range = "A1:C20")
test <- read_excel(path, range = "A1:D20")

prices <- c(A = 10, B = 20, C = 30)

final_price <- function(basket, promo_codes) {
  items <- str_split(basket, ",\\s*")[[1]]
  subtotal <- sum(unname(prices[items]))
  codes <- if (is.na(promo_codes)) character() else str_split(promo_codes, ",\\s*")[[1]]

  for (code in codes) {
    if (code == "BOGO_A") {
      subtotal <- subtotal - (sum(items == "A") %/% 2) * 10
    } else if (code == "COMBO_BC") {
      subtotal <- subtotal - min(sum(items == "B"), sum(items == "C")) * 15
    } else if (code == "TRIPLE_C") {
      subtotal <- subtotal - (sum(items == "C") %/% 3) * 30
    } else if (code == "FLAT_20") {
      subtotal <- subtotal - 20
    } else if (code == "HALF_TOT") {
      subtotal <- subtotal * 0.5
    }
  }

  max(0, subtotal)
}

result <- input %>%
  mutate(Final_Price = map2_dbl(Basket, Promo_Codes, final_price))

all.equal(result, test)
# TRUE

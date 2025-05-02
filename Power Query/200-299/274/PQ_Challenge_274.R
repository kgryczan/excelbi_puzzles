library(tidyverse)
library(readxl)
library(R6)

path = "Power Query/PQ_Challenge_274.xlsx"
input1 = read_excel(path, range = "A1:B12") %>% 
  rename("order_id" = 1, "product" = 2)
input2 = read_excel(path, range = "D1:E6") %>%
  rename("product" = 1, "quantity" = 2)
test  = read_excel(path, range = "D10:E14")

OrderFulfiller <- R6Class(
  "OrderFulfiller",
  public = list(
    inventory = NULL,
    initialize = function(inventory_df) {
      self$inventory <- inventory_df %>%
        mutate(remaining = quantity)
    },
    
    fulfill_orders = function(orders_df) {
      orders_df %>%
        mutate(row_id = row_number()) %>%
        rowwise() %>%
        mutate(
          quantity = self$fulfill_single(product)
        ) %>%
        ungroup() %>%
        select(-row_id)
    },
    
    fulfill_single = function(product_name) {
      idx <- which(self$inventory$product == product_name)
      if (length(idx) == 0) {
        return(0L)
      }
      if (self$inventory$remaining[idx] > 0) {
        self$inventory$remaining[idx] <- self$inventory$remaining[idx] - 1
        return(1L)
      } else {
        return(0L)
      }
    }
  )
)
fulfiller <- OrderFulfiller$new(input2)
fulfilled_orders <- fulfiller$fulfill_orders(input1) 

result = fulfilled_orders %>%
  filter(quantity > 0) %>%
  summarise(Ingredient = paste(sort(product), collapse = ", "), .by = order_id) %>%
  rename("Dish" = order_id)

all.equal(result, test) # TRUE

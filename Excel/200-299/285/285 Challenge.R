library(purrr)
library(tidyverse)
library(gmp)

generateDemloNumber <- function(length) {
  number <- as.bigz(paste0(rep(1, length), collapse = ""))
  result <- as.character(number^2)
  return(result)
}

demlo_sequence <- c(1:9, 8:1) %>%
  map(~generateDemloNumber(.)) %>%
  unlist() %>%
  as.data.frame(number = list(.)) 
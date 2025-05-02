library(tidyverse)
library(readxl)

input = read_excel("Excel/381 IPv6 Shortening.xlsx", range = "A1:A11")
test  = read_excel("Excel/381 IPv6 Shortening.xlsx", range = "B1:B11")

shorten_ipv6 = function(ipv6) {
  blocks = str_split(ipv6, ":")[[1]] %>%
  str_replace( "^0+", "") %>%
  str_replace("^$", "0") 

  zeros = blocks %>% 
    str_detect("^0+$") %>%
    which() %>%
    unlist()  %>%
    data.frame(x = .) %>%
    mutate(group = cumsum(x - lag(x, default = 0) > 1)) %>%
    group_by(group) %>%
    mutate(n = n(),
           min_index = min(x),
           max_index = max(x)) %>%
    ungroup() %>%
    arrange(desc(n), group) %>%
    slice(1)

  first_zero = zeros$min_index
  last_zero = zeros$max_index
  
  block_df = data.frame(blocks = blocks,
                        index = 1:length(blocks),
                        stringsAsFactors = FALSE)
  
  block_df$blocks[block_df$index >= first_zero & block_df$index <= last_zero] = ""
  
  result = block_df$blocks %>%
    str_c(collapse = ":")  %>%
    str_replace(., ":{2,}", "::")
  
  return(result)
}

result = input %>% 
  mutate(short = map_chr(`IPv6 Addresses`, shorten_ipv6))

identical(result$short, test$`Expected Answer`)
#> [1] TRUE

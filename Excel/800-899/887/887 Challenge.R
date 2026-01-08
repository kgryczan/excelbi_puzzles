library(tidyverse)
library(readxl)

path <- "Excel/800-899/887/887 Minimum Product Triplet.xlsx"
input <- read_excel(path, range = "A2:A22")
test <- read_excel(path, range = "B2:C22") %>%
  mutate_all(~ str_replace_all(., "\\{", "\\(")) %>%
  mutate_all(~ str_replace_all(., "\\}", "\\)"))


find_triplet = function(s) {
  x = as.numeric(strsplit(s, ", ")[[1]])
  c = combn(x, 3)
  m = min(p <- apply(c, 2, prod))
  t = unique(apply(apply(c[,p==m,drop=F],2,sort),2,paste,collapse=", "))
  t = t[order(rowSums(matrix(as.numeric(unlist(strsplit(t,", "))),ncol=3,byrow=T)))]
  list(`Min Product`=as.character(m), Triplets=paste0("(",paste(t,collapse=") , ("),")"))
}

result = map_dfr(input$Data, find_triplet)

all.equal(result, test, check.attributes = FALSE)
# FALSE, two cells has wrong min product in solution. And there is some sorting problems
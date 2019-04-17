library(dplyr)
library(stringr)
library(WikipediR)

source("modules/Get_Wikipedia_Domain_Categories_Module.R")
source("modules/Get_Wikipedia_Domain_Pages_Module.R")
source("modules/Get_Wikipedia_Domain_Texts_Module.R")
source("modules/Get_Wikipedia_Domain_Links_Module.R")

domain <- "Marketing"
blacklist_subcats <- c("Marketing in India", "Marketing in Pakistan", "Marketing in the United States", "Marketing people", 
                       "Works about marketing", "Marketing stubs", "Software distribution", "Video game distribution", "Computer security", 
                       "Cryptocurrencies", "DreamWorks Classics", "French wine AOCs")
blacklist_substrings <- c("\\bstubs\\b", "\\bworks\\b", "\\blists\\b")

###### GET SUBCATS FROM DOMAIN #####
degrees <- 3
t1 <- Sys.time()
edge_list_domain <- drill_down_domain(domain, blacklist_subcats, blacklist_substrings, degrees)
t2 <- Sys.time()
t2 - t1 # 3 degress: Time difference of 1.7078 mins 
saveRDS(edge_list_domain, file = "resources/marketing_domain_categories_degree3.RDS")

length(unique(edge_list_domain$super)) # 341
length(unique(edge_list_domain$sub)) # 1699

rm(list=setdiff(ls(), c("edge_list_domain")))
ls()

##### GET PAGES FROM DOMAIN #####
#edge_list_domain <- readRDS(file = "resources/marketing_domain_categories_degree3.RDS")
subcats_domain <- unique(edge_list_domain$sub)
t1 <- Sys.time()
pages_domain <- get_pages_from_all_cats(subcats_domain)
t2 <- Sys.time()
t2 - t1 # After trycatch: Time difference of 5.259306 mins | Before trycatch: Time difference of 4.792133 mins

pages_domain_vector <- unique(pages_domain$page)
saveRDS(pages_domain_vector, file = "resources/marketing_domain_pages_degree3.RDS")

rm(list=setdiff(ls(), c("pages_domain_vector")))
ls()

##### GET TEXTS FROM PAGES #####
t1 <- Sys.time()
texts_domain <- get_texts(pages_domain_vector)
t2 <- Sys.time()
t2 - t1 # After trycatch: Time difference of 2.670911 hours | Before trycatch: Time difference of 2.562519 hours
saveRDS(texts_domain, file = "resourceS/marketing_domain_texts_degree3.RDS")

rm(list=setdiff(ls(), c("pages_domain_vector")))
ls()

##### GET LINKS AND BACKLINKS FROM PAGES #####
t1 <- Sys.time()
links_domain <- get_page_links(pages_domain_vector)
t2 <- Sys.time()
t2 - t1 # After trycatch, all pages: Time difference of 3.818423 hours | Processed 14,000: Time difference of 1.370786 hours
saveRDS(links_domain, file = "resourceS/marketing_domain_links_degree3.RDS")

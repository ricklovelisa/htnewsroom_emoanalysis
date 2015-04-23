setwd("Sentiment/")
# library(RODBC)
library(tm)
library(slam)
source("../Classification/Function.R", encoding = "utf-8")

stopwordsCN <- readLines("../Classification/stopwordsCN.dic", encoding = "UTF-8")
# mycon <- odbcConnect("128.172", "root", "123456")
# hot.topic.id <- sqlQuery(mycon, "select id from htnewsroom.hot_topic where is_hot = 1", stringsAsFactors = F)
# hot.topic.id <- hot.topic.id[hot.topic.id >= 41]
# hot.topic.article.id <- list()
# for(i in 1:length(hot.topic.id)){
#   hot.topic.article.id[[i]] <- sqlQuery(mycon, paste("select article_id from htnewsroom.article_result where topic_id =", hot.topic.id[i], sep = " "), stringsAsFactors = F)
# }

# hot.topic.article.id <- sapply(hot.topic.article.id, as.vector)
# names(hot.topic.article.id) <- hot.topic.id
# select.id <- list()
# for(i in 1:length(hot.topic.id)){
#   select.id[[i]] <- list(min.id = min(hot.topic.article.id[[i]]), max.id = max(hot.topic.article.id[[i]]))
#   cat(i,"\n")
# }
# names(select.id) <- hot.topic.id
# test <- list()
# for(i in 1:length(hot.topic.id)){
#   test[[i]] <- sqlQuery(mycon, paste("select id, title, content from htnewsroom.article where id between", select.id[[i]]$min.id, "and", select.id[[i]]$max.id, sep = " "),stringsAsFactors = F)
#   test[[i]] <- test[[i]][test[[i]]$id %in% hot.topic.article.id[[i]], ]
#   cat(i,"\n")
# }

# saveRDS(test,"../Sentiment/Data_&_Model/test.rds")

# 清理数据集 #
test <- readRDS("Data_&_Model/test.rds")
test[[1]]$content <- gsub("[a-zA-Z]", "", test[[1]]$content)
test[[1]]$content <- gsub("^</.*>$", "", test[[1]]$content)
removePunctuation(removeNumbers(removeWords(x, stopwordsCN)))
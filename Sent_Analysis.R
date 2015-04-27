# library(RODBC)
library(tm)
library(slam)
library(jiebaR)
source("Function.R", encoding = "utf-8")

stopwordsCN <- readLines("stopwordsCN.dic", encoding = "UTF-8")
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

cutter <- worker()

# 清理数据集 #
data <- readRDS("test.rds")
data1 <- data[[1]]
data1$content <- sapply(data1$content, function(x) gsub("<.*?>", "", x))
data1$content <- sapply(data1$content, function(x) gsub("(http[^ ]*)", "", x))
list.title <- sapply(data1$title, function(x) cutter[x])
list.content <- sapply(data1$content, function(x) cutter[x])
names(list.title) <- data1$id
names(list.content) <- data1$id
list.both <- sapply(1:75, function(x) list(list(c(list.title[[x]], list.content[[x]]))))
names(list.both) <- data1$id

rm(list.content,list.title)
corpus.both <- Corpus(VectorSource(list.both))
for (i in 1:length(corpus.both)){
  corpus.both[[i]]$content <- sub("c", "", corpus.both[[i]]$content)
}
for (i in 1:length(corpus.both)){
  meta(corpus.both[[i]], tag = 'id') <- data1$id[i]
}

control.tf<-list(removePunctuation = T, stripWhitespace = T, wordLengths = c(2, 10))
dtm.both <- DocumentTermMatrix(corpus.both, control.tf)

emo <- ClassifyEmotion(dtm.both, "bayes", 1, T)





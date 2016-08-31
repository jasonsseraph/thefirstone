rm(list=ls(all=TRUE))
#install.packages("jiebaR")
#install.packages("tm")
#install.packages("slam")
#install.packages("RColorBrewer")
#install.packages("wordcloud")
#install.packages("topicmodels")
#install.packages("igraph")
#install.packages("xml2")

library(jiebaRD)
library(jiebaR)       # 斷詞利器
library(NLP)
library(tm)           # 文字詞彙矩陣運算
library(slam)         # 稀疏矩陣運算
library(RColorBrewer)
library(wordcloud)    # 文字雲
library(topicmodels)  # 主題模型
library(plyr)

#Sys.setlocale("LC_ALL", "cht")

source('textsave.R')

result = textsave

orgpath = "./allText"
text = Corpus(DirSource(orgpath), list(language = NA))
text <- tm_map(text, removePunctuation)
text <- tm_map(text, removeNumbers)
text <- tm_map(text, function(word)
{ gsub("[A-Za-z0-9]", "", word) })

# 進行中文斷詞
mixseg = worker()
mat <- matrix( unlist(text) )
totalSegment = data.frame()
for( j in 1:length(mat) )
{
  for( i in 1:length(mat[j,]) )
  {
    result = segment(as.character(mat[j,i]), jiebar=mixseg)
  }
  totalSegment = rbind(totalSegment, data.frame(result))
}

# define text array that you want
# delete text length < 2
delidx = which( nchar(as.vector(totalSegment[,1])) < 2 )

#清除一些常用但是沒有意義的字
myStopWords <- c(stopwordsCN(), "作者", "時間", "標題")
d.corpus <- tm_map(d.corpus, removeWords, myStopWords)

countText = totalSegment[-delidx,]
countResult = count(countText)[,1]
countFreq = count(countText)[,2] / sum(count(countText)[,2])
wordcloud(countResult, countFreq, min.freq = 1, random.order = F, ordered.colors = T, 
          colors = rainbow(length(countResult)))

#關鍵字的關聯
 #d.dtm <- DocumentTermMatrix(d.corpus, control = list(wordLengths = c(2, Inf)))
 #inspect(d.dtm[1:10, 1:2])

  #找出與""相關程度0.5上的關鍵字

   #findAssocs(d.dtm, "", 0.5)




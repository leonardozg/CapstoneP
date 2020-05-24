
library(ggplot2)
library(ngram)
library(NLP)
library(tm)
library(RWeka)
library(data.table)
library(stringr)
library(dplyr)
library(tm)
library(wordcloud2)


#Sample the data


setwd("~/skydrive/1000-Capacitacion/2015-Coursera/11-Capstone")
blogs <- file("./Data/final/en_US/en_Us.blogs.txt", "r")
news <- file("./Data/final/en_US/en_Us.news.txt", "r")
twitt <- file("./Data/final/en_US/en_Us.twitter.txt", "r")

ptm <- proc.time()
blogs <- readLines(blogs, encoding="UTF-8", skipNul = TRUE, warn = TRUE)
news <- readLines(news, encoding="UTF-8", skipNul = TRUE, warn = TRUE)
twitt <- readLines(twitt,encoding="UTF-8", skipNul = TRUE, warn = TRUE)

set.seed(1130)
samp_size = 5000

blogs_samp <- blogs[sample(1:length(blogs),samp_size)]
news_samp <- news[sample(1:length(news),samp_size)]
twitt_samp <- twitt[sample(1:length(twitt),samp_size)]

df <-rbind(blogs_samp, news_samp,twitt_samp)
rm(blogs, news,twitt)

#Obtain the corpus
corp <- VCorpus(VectorSource(df), readerControl=list(readPlain, language="en", load=TRUE))

corp <- tm_map(corp, content_transformer(tolower))
corp <- tm_map(corp, removePunctuation)
corp <- tm_map(corp, removeWords,stopwords("english"))
corp <- tm_map(corp, removeNumbers)
corp <- tm_map(corp, stripWhitespace)
corp <- tm_map(corp, PlainTextDocument)
changetospace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
corp <- tm_map(corp, changetospace, "/|@|\\|")

#Idicative WordClouds of N-Grams
gram1 = as.data.frame((as.matrix(  TermDocumentMatrix(corp) )) ) 
gram1v <- sort(rowSums(gram1),decreasing=TRUE)
gram1d <- data.frame(word = names(gram1v),freq=gram1v)
gram1d[1:10,]

wc1<- wordcloud2(gram1d[1:50,],size=0.4,shape = 'circle')

bigram <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
gram2= as.data.frame((as.matrix(  TermDocumentMatrix(corp,control = list(tokenize = bigram)) )) ) 
gram2v <- sort(rowSums(gram2),decreasing=TRUE)
gram2d  <- data.frame(word = names(gram2v),freq=gram2v)
gram2d[1:10,]


wc2 <- wordcloud2(gram2d[1:50,],size=0.3,shape = 'circle', rotateRatio = 0, gridSize = 2)


#use a tokenizer to transform paragraphs in words to count and read by algorithm
uniGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
biGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
triGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
quadGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
OneT <- NGramTokenizer(corp, Weka_control(min = 1, max = 1))
oneGM <- TermDocumentMatrix(corp, control = list(tokenize = uniGramTokenizer))
twoGM <- TermDocumentMatrix(corp, control = list(tokenize = biGramTokenizer))
threeGM <- TermDocumentMatrix(corp, control = list(tokenize = triGramTokenizer))
fourGM <- TermDocumentMatrix(corp, control = list(tokenize = quadGramTokenizer))

#Find the most frequent terms (FourGrams)
freqTerms4 <- findFreqTerms(fourGM, lowfreq = 1)
termFreq4 <- rowSums(as.matrix(fourGM[freqTerms4,]))
termFreq4 <- data.frame(quadgram=names(termFreq4), frequency=termFreq4)
quadgramlist <- setDT(termFreq4)
save(quadgramlist,file="quadgram.Rds")

#Find the most frequent terms (ThreeGrams)
freqTerms3 <- findFreqTerms(threeGM, lowfreq = 2)
termFreq3 <- rowSums(as.matrix(threeGM[freqTerms3,]))
termFreq3 <- data.frame(trigram=names(termFreq3), frequency=termFreq3)
trigramlist <- setDT(termFreq3)
save(trigramlist,file="trigram.Rds")

#Find the most frequent terms (BiGrams)
freqTerms2 <- findFreqTerms(twoGM, lowfreq = 3)
termFreq2 <- rowSums(as.matrix(twoGM[freqTerms2,]))
termFreq2 <- data.frame(bigram=names(termFreq2), frequency=termFreq2)
termFreq2 <- termFreq2[order(-termFreq2$frequency),]
bigramlist <- setDT(termFreq2)
save(bigramlist,file="bigram.Rds")

#Find the most frequently terms (Unigrams)
freqTerms1 <- findFreqTerms(oneGM, lowfreq = 5)
termFreq1 <- rowSums(as.matrix(oneGM[freqTerms1,]))
termFreq1 <- data.frame(unigram=names(termFreq1), frequency=termFreq1)
termFreq1 <- termFreq1[order(-termFreq1$frequency),]
unigramlist <- setDT(termFreq1)
save(unigramlist,file="unigram.Rds")







timecomp <- proc.time() -ptm


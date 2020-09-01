#Libraries needed
library(qdapDictionaries)
library(qdapRegex)
library(qdapTools)
library(RColorBrewer)
library(NLP)
library(tm)
library(SnowballC)
library(slam)
library(wordcloud)
library(stringr)
library(stringi)
library(ngram)
library(rJava)
library(RWeka)
library(ggplot2)
library(ggthemes)
library(dplyr)
library(tidyr)

#Load data - after setting working directory

blogs = readLines("en_US.blogs.txt", encoding = "UTF-8", skipNul = T)
news = readLines("en_US.news.txt", encoding = "UTF-8", skipNul = T)
twitter = readLines("en_US.twitter.txt", encoding = "UTF-8", skipNul = T)

data = c(blogs, news, twitter)

writeLines(data, "complete_data.txt")

#Data overview
blogs_size = utils:::format.object_size(file.size("en_US.blogs.txt"), "auto")
news_size = utils:::format.object_size(file.size("en_US.news.txt"), "auto")
twitter_size = utils:::format.object_size(file.size("en_US.twitter.txt"), "auto")

blogs_lines = length(blogs)
news_lines = length(news)
twitter_lines = length(twitter)

blogs_char = nchar(blogs)
news_char = nchar(news)
twitter_char = nchar(twitter)
blog_longest = max(blogs_char)
news_longest = max(news_char)
twitter_longest = max(twitter_char)
blogsChar = sum(blogs_char)
newsChar = sum(news_char)
twitterChar = sum(twitter_char)

File = c("Blogs", "News", "Twitter")
Size = c(blogs_size, news_size, twitter_size)
Lines_number = c(blogs_lines, news_lines, twitter_lines)
Longest_line_length = c(blog_longest, news_longest, twitter_longest) 
Characters = c(blogsChar, newsChar, twitterChar)

data_summary = data.frame(cbind(File, Size, Lines_number, Longest_line_length, Characters))
data_summary

#Saving summary
saveRDS(data_summary, file = "data_summary.Rda")
Summary_table = readRDS("data_summary.Rda")
Summary_table

#Do sampling of data
blogs_sample = blogs[sample(1:length(blogs),15000)]
news_sample = news[sample(1:length(news),15000)]
twitter_sample = twitter[sample(1:length(twitter),15000)]

sample_data = c(blogs_sample, news_sample, twitter_sample)

writeLines(sample_data, "sample_data.txt")

#Building a corpus
SampleData = readLines("sample_data.txt", encoding = "UTF-8")
BannedWords = read.table("swearWords.txt", header = F)

Sample_final = VCorpus(VectorSource(SampleData))

#Cleaning the sample corpus
Sample_final = tm_map(Sample_final, 
                      content_transformer(function(x)
                        iconv(x, to = "UTF-8", sub = "byte")))

Sample_final = tm_map(Sample_final, content_transformer(tolower))
Sample_final = tm_map(Sample_final, content_transformer(removePunctuation))
Sample_final = tm_map(Sample_final, content_transformer(removeNumbers))
Sample_final = tm_map(Sample_final, content_transformer(function(x)
  gsub("http[[:alnum:]]*", " ", x)))
Sample_final = tm_map(Sample_final, stripWhitespace)
Sample_final = tm_map(Sample_final, removeWords, stopwords("english")) #See note below
Sample_final = tm_map(Sample_final, removeWords, BannedWords[,1])

saveRDS(Sample_final, "final_sampleCorpus.RDS")

#Exploratory analysis
final_corpus = readRDS("final_sampleCorpus.RDS")
corpus_DF = data.frame(text = unlist(sapply(final_corpus,`[`, "content")), stringsAsFactors = F)

tokenize_function = function(Corpus, N){
  Ngram = NGramTokenizer(Corpus, 
                         Weka_control(min = N, max = N,
                                      delimiters = " \\r\\n\\t.,;:\"()?!"))
  Ngram = data.frame(table(Ngram))
  Ngram = Ngram[order(Ngram$Freq, decreasing = T),]
  colnames(Ngram) = c("String", "Count")
  Ngram
}

#Ngrams
unigram = tokenize_function(corpus_DF,1)
bigram = tokenize_function(corpus_DF,2)
trigram = tokenize_function(corpus_DF,3)
quadgram = tokenize_function(corpus_DF,4)

#Arrange and plot results
unigram_df = data.frame(unigram)%>%arrange(desc(Count))
bigram_df = data.frame(bigram)%>%arrange(desc(Count))
trigram_df = data.frame(trigram)%>%arrange(desc(Count))
quadgram_df = data.frame(quadgram)%>%arrange(desc(Count))

UniDF = unigram_df[1:20,]
BiDF = bigram_df[1:20,]
TriDF = trigram_df[1:20,]
QuadDF = quadgram_df[1:20,]

P_1gram = ggplot(UniDF) + geom_bar(aes(reorder(String,+Count), Count), stat = "identity", fill = "navajowhite3", alpha = I(3/5)) + 
  xlab("String\n") + ylab("Count\n") + coord_flip() + theme_minimal()
P_2gram = ggplot(BiDF) + geom_bar(aes(reorder(String,+Count), Count), stat = "identity", fill = "palegreen3", alpha = I(3/5)) + 
  xlab("String\n") + ylab("Count\n") + coord_flip() + theme_minimal()
P_3gram = ggplot(TriDF) + geom_bar(aes(reorder(String,+Count), Count), stat = "identity", fill = "slategray3", alpha = I(3/5)) + 
  xlab("String\n") + ylab("Count\n") + coord_flip() + theme_minimal()
P_4gram = ggplot(QuadDF) + geom_bar(aes(reorder(String,+Count), Count), stat = "identity", fill = "mediumpurple", alpha = I(3/5)) + 
  xlab("String\n") + ylab("Count\n") + coord_flip() + theme_minimal()

#plots
P_1gram
P_2gram
P_3gram
P_4gram

wordcloud(unigram_df$String, unigram_df$Count, max.words = 100, colors = brewer.pal(6, 'Dark2'))
wordcloud(bigram_df$String, bigram_df$Count, max.words = 20, colors = brewer.pal(6, 'Dark2'))
wordcloud(trigram_df$String, trigram_df$Count, max.words = 100, colors = brewer.pal(6, 'Dark2'))

#Save data
saveRDS(unigram, "unigram.RDS")
saveRDS(bigram, "bigram.RDS")
saveRDS(trigram, "trigram.RDS")
saveRDS(quadgram, "quadgram.RDS")

unigram = readRDS("unigram.RDS")
bigram = readRDS("bigram.RDS")
trigram = readRDS("trigram.RDS")

Coverage_length = function(numbers, coverage){
  N = length(numbers)
  S = sum(numbers)
  prop = vector("numeric", N)
  for(i in 1:N){
    prop[i] = numbers[i]/S
  }
  Prop_sum = cumsum(prop)
  ind = which(Prop_sum >= coverage)[1]
  return(ind)
}
Coverage_length(unigram$Count, 0.5)
Coverage_length(bigram$Count, 0.5)
Coverage_length(trigram$Count, 0.5)

#Repeat the script without deleting stop words, and create 3 more seperate RDS files, containing the 
#uni, bi, and trigrams with stop words.



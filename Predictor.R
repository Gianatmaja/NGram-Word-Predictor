#Set up
library(dplyr)

#Compile into neat n-grams
unigram = readRDS("unigram.RDS")
bigram = readRDS("bigram.RDS")
trigram = readRDS("trigram.RDS")
quadgram = readRDS("quadgram.RDS")

unigramSW = readRDS("unigram_with_SW.RDS")
bigramSW = readRDS("bigram_with_SW.RDS")
trigramSW = readRDS("trigram_with_SW.RDS")

Unigrams = rbind(unigramSW[1:100,], unigram)
Bigrams = rbind(bigramSW[1:200,], bigram)
Trigrams = rbind(trigramSW[1:500,], trigram)
Quadgrams = quadgram[1:10000,]

UnigramsDF = data.frame(Unigrams) %>% arrange(desc(Count))
BigramsDF = data.frame(Bigrams) %>% arrange(desc(Count))
TrigramsDF = data.frame(Trigrams) %>% arrange(desc(Count))
QuadgramsDF = data.frame(Quadgrams) %>% arrange(desc(Count))

UnigramsDF$String = as.character(UnigramsDF$String)
BigramsDF$String = as.character(BigramsDF$String)
TrigramsDF$String = as.character(TrigramsDF$String)
QuadgramsDF$String = as.character(QuadgramsDF$String)

Unigram_perWord = UnigramsDF
names(Unigram_perWord) = c("Word1", "Count")
Bigram_perWord = BigramsDF %>% 
  separate(String, c("Word1", "Word2"), sep = " ")
Trigram_perWord = TrigramsDF %>% 
  separate(String, c("Word1", "Word2", "Word3"), sep = " ")
Quadgram_perWord = QuadgramsDF %>% 
  separate(String, c("Word1", "Word2", "Word3", "Word4"), sep = " ")

#Save final n-grams
saveRDS(Unigram_perWord, "UnigramFinal.RDS")
saveRDS(Bigram_perWord, "BigramFinal.RDS")
saveRDS(Trigram_perWord, "TrigramFinal.RDS")
saveRDS(Quadgram_perWord, "QuadgramFinal.RDS")

#Reading the files
UnigramData = readRDS("UnigramFinal.RDS")
BigramData = readRDS("BigramFinal.RDS")
TrigramData = readRDS("TrigramFinal.RDS")
QuadgramData = readRDS("QuadgramFinal.RDS")

RandPool = as.character(UnigramData$Word1[1:10])

#Function
#Final code
#Function
BigramPred = function(input){
  N = length(input)
  Chosen = filter(BigramData, Word1 == input[N])
  out = Chosen[1,2]
  if(dim(Chosen)[1] == 0){
    Out = sample(RandPool, 1)
  }else{
    Out = out
  }
}

TrigramPred = function(input){
  N = length(input)
  Chosen = filter(TrigramData, Word1 == input[N-1], Word2 == input[N])
  out = Chosen[1,3]
  if(dim(Chosen)[1] == 0){
    Out = BigramPred(input)
  }else{
    Out = out
  }
}

QuadgramPred = function(input){
  N = length(input)
  Chosen = filter(QuadgramData, Word1 == input[N-2], Word2 == input[N-1], Word3 == input[N])
  out = Chosen[1,4]
  if(dim(Chosen)[1] == 0){
    Out = TrigramPred(input)
  }else{
    Out = out
  }
}

Predictor = function(input){
  In = gsub(" ", "", input)
  input = strsplit(input, " ")[[1]]
  input = tolower(input)
  N = length(input)
  if(In == ""){
    Out = "Please enter a word"
  }else{
    if(N >= 3){
      Out = QuadgramPred(input)
    }else if (N == 2){
      Out = TrigramPred(input)
    }else{
      Out = BigramPred(input)
    }
  }
  return(Out)
}





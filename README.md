# NGram-Word-Predictor

### Quick Links:
- [Go to web application](https://gian-atmaja.shinyapps.io/Word_Predict/)
- [Codes for initial analysis](https://github.com/Gianatmaja/NGram-Word-Predictor/blob/master/InitialAnalysis.R)
- [Codes for predictor function](https://github.com/Gianatmaja/NGram-Word-Predictor/blob/master/Predictor.R)
- [Initial analysis report](https://rpubs.com/Ga25/624781)
- [Data](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip)

### Description:
This web application takes your text input and predicts the next most likely word. The model is created using ngrams.
Text data from twitter, blogs, and news were extracted and combined into a corpus. After cleaning it, tokenization was 
performed in order to extract the most frequent ngrams, where n in this case is 1 to 4. 

The model works by first counting how many words are typed. If there are at least 3 words, then it will search for the
next likely word based on the quadgram data. If there's less than 3 words, or if the preceeding words were unfamiliar to
the model, it then uses the trigram data. The same process goes for bigram. If the model does not understand the word/s
completely, then it will return one of the most likely word in random.

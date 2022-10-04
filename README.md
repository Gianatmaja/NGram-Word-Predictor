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

### Some Results from Analysis
Based on the analysis performed on the dataset, we obtain the following results:
![Wordcloud from Analysis](https://github.com/Gianatmaja/NGram-Word-Predictor/blob/master/Images/Screenshot%202022-10-04%20at%201.29.40%20PM.png)

As seen from the wordcloud, larger words such as said, will, and one appear more frequently in the dataset, while words
like night, team, and show appear less frequently.

![Bigram](https://github.com/Gianatmaja/NGram-Word-Predictor/blob/master/Images/Screenshot%202022-10-04%20at%201.29.52%20PM.png)

For the bigrams, phrases such as 'last year', 'New York', and 'right now' were among those most used in the dataset. 

![Trigram](https://github.com/Gianatmaja/NGram-Word-Predictor/blob/master/Images/Screenshot%202022-10-04%20at%201.30.00%20PM.png)

Finally, for the trigrams, the top 3 that are most frequently present include 'New York City', 'President Barack Obama', and 'let us know'. 

### Web App in Action
Some screenshots of the n-gram word predictor in action can be seen below.

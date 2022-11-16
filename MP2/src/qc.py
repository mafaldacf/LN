#---Natural Language MP2
#-Grupo 16
#-92513 Mafalda Ferreira
#-92546 Rita Oliveira

#########################################################################################
############################# |QUESTION CLASSIFICATION| #################################
#########################################################################################

import sys

from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics import accuracy_score
from sklearn import svm

import nltk
nltk.download('punkt')
nltk.download("stopwords")
from nltk.stem import PorterStemmer
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from sklearn.metrics import confusion_matrix

import string

x_train = []
y_train = []
x_test = []
y_test = []

stop_words = set(stopwords.words("english"))
punctuation = [',','(',')','&','\'\'', '"', '-', '!', ':', '%', '[', ']', '?', ';', '<', '>', '$', '\\', '/', '+']

# Print accuracy for each label
def get_labels_accuracy(y_test, y_predict):
    labels = ['GEOGRAPHY', 'MUSIC', 'LITERATURE', 'HISTORY', 'SCIENCE']
    matrix = confusion_matrix(y_test, y_predict, labels=labels)
    results = matrix.diagonal()/matrix.sum(axis = 1)
    print(results)

# Print accuracy score
def get_accuracy(y_test, y_predict):
    accuracy = accuracy_score(y_test, y_predict)
    print('Accuracy score =', accuracy*100, '%.\n')

# Print predicted test labels to stdout       
def get_results(y_predict):
    for label in y_predict:
        print(label)
        
#Filter
def filter(list):
    new_list = []
    for line in list:
        token_list=[]
        for token in line:
            if token not in stop_words and token not in punctuation:
                token_list.append(token)
        new_list.append(token_list)
    return new_list

#Stemming
def stemming(list):
    porter_stemmer = PorterStemmer()
    new_list = []
    for line in list:
        stemmed_tokens = []
        for token in line:
            stemmed_tokens.append(porter_stemmer.stem(token))
        new_list.append(stemmed_tokens)
    return new_list

#Jaccard
def jaccard(tokens_test,tokens_train):
    set_test = set(tokens_test)
    set_train = set(tokens_train)

    intersec = list(set_test & set_train)
    len_intersec = len(intersec)
    
    len_union = len(set_test) + len(set_train) - len_intersec
    return len_intersec/len_union

# Classification model based on a Jaccard, Stemming and filter stop words and punnctuation marks
def jaccard_classifier():
    #print("##### Jaccard + Stemming + Filter #####\n")

    tokens_train = []
    for line in x_train:
        tokens_train.append(word_tokenize(line))

    tokens_test = []
    for line in x_test:
        tokens_test.append(word_tokenize(line))

    #----Filter----
    clean_tokens_train = filter(tokens_train)
    clean_tokens_test = filter(tokens_test)

    #-----Stemming----
    stemmed_tokens_train = stemming(clean_tokens_train)
    stemmed_tokens_test = stemming(clean_tokens_test)

    #---Jaccard---
    len_train = len(stemmed_tokens_train)
    len_test = len(stemmed_tokens_test)

    y_predict = []
    jaccard_values = []

    for i in range(len_test):
        for j in range(len_train):
            jaccard_values.append(jaccard(stemmed_tokens_test[i],stemmed_tokens_train[j]))
        max_jaccard = max(jaccard_values)
        max_j = jaccard_values.index(max_jaccard)
        jaccard_values = []
        y_predict.append(y_train[max_j])

    #get_labels_accuracy(y_test, y_predict)
    #get_accuracy(y_test, y_predict)
    #get_results(y_predict)

# Tokenizer for vector classification pre-processing
def tokenize(line):
    tokens = word_tokenize(line)
    clean_tokens = filter([tokens])
    stemmed_tokens = stemming(clean_tokens)
    return stemmed_tokens[0]
    
 
# Classification model based on a Support Vector Classifier and a CountVectorizer
def vector_classifier():
    #print("##### Count Vectorizer & Support Vector Classification #####\n")
    vectorizer = CountVectorizer(ngram_range = (1, 2), token_pattern = None, tokenizer = tokenize)

    vectorizer.fit(x_train)
    
    x_train_count = vectorizer.transform(x_train)
    x_test_count = vectorizer.transform(x_test)

    classifier = svm.LinearSVC()
    classifier.fit(x_train_count, y_train)

    y_predict = classifier.predict(x_test_count)

    #get_labels_accuracy(y_test, y_predict)
    #get_accuracy(y_test, y_predict)
    get_results(y_predict)


# Process data for each newline and add each sentence and label to the corresponding set
def process_data(test_file, train_file):
    with open(test_file, 'r') as f:
        for line in f:
            data = line.split('\t', 1)
            y_test.append(data[0])
            corpus = data[1].split('\n', 1)[0]
            x_test.append(corpus)
    
    with open(train_file, 'r') as f:
        for line in f:
            data = line.split('\t', 1)
            y_train.append(data[0])
            corpus = data[1].split('\n', 1)[0]
            x_train.append(corpus)

# Program Usage
def usage(prog_name):
    print('[-] Missing input files.')
    print('[-] Usage: %s –test <test_file> –train <train_file> > results.tx' % prog_name)
    sys.exit()

# Main Function
if __name__ == '__main__':
    n = len(sys.argv)
    i=1

    test_file = None
    train_file = None
    if n < 5:
        usage(sys.argv[0])
    
    while i < n - 1:
        if sys.argv[i] == '-test':
            test_file = sys.argv[i+1]
            i+=2
        elif sys.argv[i] == '-train':
            train_file = sys.argv[i+1]
            i+=2
        else:
            i+=1

    process_data(test_file, train_file)
    #jaccard_classifier()
    vector_classifier()

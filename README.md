# Natural Language Processing Mini Projects

## Authors 

Group 19

92513 Mafalda Ferreira

92546 Rita Oliveira

## Mini Project 1

Develop, test and use the following transducers: 
- `mm2mmm`: converts from 2-digit Arabic numbers to 3-letter (english) month names (e.g., $\color{blue}{06}$ → $\color{blue}{Jun}$);
- `d2dd`: converts Arabic numbers with a single digit to 2-digit numbers (e.g., $\color{blue}{8}$ → $\color{blue}{08}$). Numbers with 2 or more digits are unchanged;
- `d2dddd`: converts Arabic numbers with 1, 2, or 3-digits to 4-digit numbers (e.g., $\color{blue}{8}$ → $\color{blue}{0008}$, $\color{blue}{62}$ → $\color{blue}{0062}$, $\color{blue}{753}$ → $\color{blue}{0753}$). Numbers with 4 or more digits are unchanged.
- `copy`: only accepts a single symbol: a digit or a "/" (e.g., $\color{blue}{0}$ → $\color{blue}{0}$, $\color{blue}{1}$ → $\color{blue}{1}$, $\color{blue}{8}$ → $\color{blue}{8}$, $\color{blue}{9}$ → $\color{blue}{9}$, $\color{blue}{/}$ → $\color{blue}{/}$) and fails if the input consists of any other symbol;
- `skip`: converts a single symbol: a digit or a "/" into "eps" (e.g., $\color{blue}{0}$ → $\color{blue}{eps}$, $\color{blue}{1}$ → $\color{blue}{eps}$, $\color{blue}{8}$ → $\color{blue}{eps}$, $\color{blue}{9}$ → $\color{blue}{eps}$, $\color{blue}{/}$ → $\color{blue}{eps}$) and fails if the input consists of any other symbol;
- `date2year`: selects the year in Arabic birthdates (e.g., $\color{blue}{08/09/2013}$ → $\color{blue}{2013}$);
- `leap`: analyses whether one year (4-digit numbers between 1901 and 2099) is a "not-leap" or a "leap" year (e.g., $\color{blue}{1901}$ → $\color{blue}{not-leap}$, $\color{blue}{1904}$ → $\color{blue}{leap}$);
- `R2A`: converts Roman numerals to Arabic numbers (e.g., $\color{blue}{VIII}$ → $\color{blue}{8}$, $\color{blue}{CIX}$ → $\color{blue}{109}$, $\color{blue}{MMXIII}$ → $\color{blue}{2013}$). There is no need to consider numbers beyond $\color{blue}{MMMCMXCIX}$ (3999);

Additional transducers developed using the previous ones:
- `A2R`: converts Arabic numbers to Roman numbers (e.g., $\color{blue}{8}$ → $\color{blue}{VIII}$, $\color{blue}{109}$ → $\color{blue}{CIX}$, $\color{blue}{2013}$ → $\color{blue}{MMXIII}$);
- `birthR2A`: converts Roman birthdates to Arabic birthdates (e.g., $\color{blue}{VIII/IX/CCCXIII}$ → $\color{blue}{08/09/0313}$);
- `birthA2T`: converts Arabic birthdates to Arabic-text format birthdates (e.g., $\color{blue}{08/09/0313}$ → $\color{blue}{08/Sep/0313}$);
- `birthT2R`: converts Arabic-text birthdates to Roman birthdates (e.g., $\color{blue}{08/Sep/2013}$ → $\color{blue}{VIII/IX/MMXIII}$);
- `birthR2L`: converts Roman birthdates to leap/not-leap (e.g., $\color{blue}{VIII/IX/MMXIII}$ → $\color{blue}{not-leap}$ and $\color{blue}{VIII/IX/MMXII}$ → $\color{blue}{leap}$);

### Set up and run the project

Folders:
- The folder `sources` contains all the text files used to define the developed transducers (extension ".txt");
- The folder `tests` contains all test files (extensions ".txt");
- The folder `compiled` contains all the compiled version of all the transducers used, including the tests (extension ".fst");
- The folder `images` contains the graphical versions of all developed transducers, including the tests (extension ".pdf");

The script `run.sh` compiles all developed transducers (extension ".fst") and generates the corresponding images (extension ".pdf"). Then, it runs all tests (prefix "92513" and "92546") and compiles and generates the corresponding images for the obtained transducers (prefix "92513" and "92546").

Run the project using shell script:

    ./run.sh

## Mini Project 2

Simulate an evaluation forum. International evaluation forums are competitions in which participants test their systems in specific tasks and in the same conditions. Training/development sets are given in advance, and, on a certain predefined date, a test set is released. Then, participants have a short period of time to return the output of their systems, which is evaluated and straightfowardly compared with one another, resulting in a final ranking where the state-of-the-art system is acknowledged. 

Two models were developed:
- The first model is based on Jaccard, Stemming and the Stop Words and signals filter of score. Tokens are removed from questions and Stop Words and Unnecessary punctuation marks in questions and answers. Afterwards, the stemming in words. Finally, the Jaccard is used to find the question in the training more similar to the question on the test. The template prevents the test question from getting the workout question tag.
- The second model takes advantage of the filter pre-processing of Stop Words and scores already developed. This model is based on the combination of the two concepts Linear Support Vector Classifier and Count Vectorizer, the latter of which uses a scale of ngram's between one and two, considering, therefore, unigram's and bigram's.

### Set up and run the project

    python qc.py –test dev.txt –train train.txt > results.txt

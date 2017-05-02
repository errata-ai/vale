import json
import os

from nltk.tokenize import wordpunct_tokenize

if __name__ == '__main__':
    with open(os.path.join('testdata', 'treebank_sents.json')) as d:
        data = json.load(d)

    words = []
    for s in data:
        words.append(wordpunct_tokenize(s))

    with open(os.path.join('testdata', 'word_punct.json'), 'w') as f:
        json.dump(words, f, indent=4)

# -*- coding: utf-8 -*-
import sys
from spacy.en import English

if __name__ == '__main__':
    nlp = English()
    doc = nlp(sys.stdin.read())

    for sent in doc.sents:
        print(sent.text)
        print("{{sentence_break}}")

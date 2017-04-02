import sys
import nltk

if len(sys.argv) < 2:
    raise Exception("NLTK requires a data file, please supply the file + location as the first arg in script")

load = nltk.data.load(sys.argv[1])
#load._params.abbrev_types.add('etc')
#load._params.abbrev_types.add('al')

sentences = load.tokenize(sys.stdin.read())
for s in sentences:
    print(s)
    print('{{sentence_break}}')

from nltk.corpus import treebank
from nltk.tag.util import untag

sentences = treebank.tagged_sents()
text = []
for s in sentences:
    text.append(' '.join(untag(s)))
print(' '.join(text))

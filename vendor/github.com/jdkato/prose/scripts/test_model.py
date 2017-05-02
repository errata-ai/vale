import itertools
import json
import os
import subprocess as sp
import time

from nltk.corpus import treebank
from nltk.metrics import accuracy
from nltk.tag.api import TaggerI
from nltk.tag.perceptron import PerceptronTagger
from nltk.tag.util import untag

from tabulate import tabulate

AP_TIME = None


def pipe_through_prog(prog, text):
    global AP_TIME
    p1 = sp.Popen(prog.split(), stdout=sp.PIPE, stdin=sp.PIPE, stderr=sp.PIPE)
    now = time.time()
    [result, err] = p1.communicate(input=text.encode('utf-8'))
    AP_TIME = time.time() - now
    tags = [(t['Text'], t['Tag']) for t in json.loads(result.decode('utf-8'))]
    return [p1.returncode, tags, err]


class APTagger(TaggerI):
    """A wrapper around the aptag Go library.
    """
    def tag(self, tokens):
        prog = os.path.join('bin', 'prose')
        ret, tags, err = pipe_through_prog(prog, ' '.join(tokens))
        return tags

    def tag_sents(self, sentences):
        text = []
        for s in sentences:
            text.append(' '.join(s))
        return self.tag(text)

    def evaluate(self, gold):
        tagged_sents = self.tag_sents(untag(sent) for sent in gold)
        gold_tokens = list(itertools.chain(*gold))
        return accuracy(gold_tokens, tagged_sents)


if __name__ == '__main__':
    sents = treebank.tagged_sents()
    PT = PerceptronTagger()
    now = time.time()
    PT.tag_sents(untag(sent) for sent in sents)
    pt_time = time.time() - now
    headers = ['Library', 'Accuracy', 'Time (sec)']
    table = [
        ['NLTK', round(PT.evaluate(sents), 3), round(pt_time, 3)],
        ['Prose', round(APTagger().evaluate(sents), 3), round(AP_TIME, 3)]
    ]
    print(tabulate(table, headers, tablefmt='pipe'))

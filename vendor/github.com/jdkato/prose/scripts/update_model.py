import pickle
import json
import os

MODEL_PATH = os.path.join(os.getcwd(), 'model')
HOME = os.path.expanduser("~")
DATA_PATH = 'nltk_data/taggers/averaged_perceptron_tagger'
DATA_FILE = 'averaged_perceptron_tagger.pickle'


def dump_model(model, data):
    if type(data) is set:
        data = list(data)
    with open(os.path.join(MODEL_PATH, model), 'w+') as mod:
        json.dump(data, mod)

with open(os.path.join(HOME, DATA_PATH, DATA_FILE), 'rb') as f:
    w_td_c = pickle.load(f)
    weights, tagdict, classes = w_td_c

dump_model('tags.json', tagdict)
dump_model('weights.json', weights)
dump_model('classes.json', classes)

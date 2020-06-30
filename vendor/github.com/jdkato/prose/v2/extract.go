package prose

import (
	"encoding/gob"
	"math"
	"os"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"
	"unicode"

	mapset "github.com/deckarep/golang-set"
	"gonum.org/v1/gonum/mat"
)

var maxLogDiff = math.Log2(1e-30)

type mappedProbDist struct {
	dict map[string]float64
	log  bool
}

func (m *mappedProbDist) prob(label string) float64 {
	if p, found := m.dict[label]; found {
		return math.Pow(2, p)
	}
	return 0.0
}

func newMappedProbDist(dict map[string]float64, normalize bool) *mappedProbDist {
	if normalize {
		values := make([]float64, len(dict))
		i := 0
		for _, v := range dict {
			values[i] = v
			i++
		}
		sum := sumLogs(values)
		if sum <= math.Inf(-1) {
			p := math.Log2(1.0 / float64(len(dict)))
			for k := range dict {
				dict[k] = p
			}
		} else {
			for k := range dict {
				dict[k] -= sum
			}
		}
	}
	return &mappedProbDist{dict: dict, log: true}
}

type encodedValue struct {
	key   int
	value int
}

type feature struct {
	label    string
	features map[string]string
}

type featureSet []feature

var featureOrder = []string{
	"bias", "en-wordlist", "nextpos", "nextword", "pos", "pos+prevtag",
	"prefix3", "prevpos", "prevtag", "prevword", "shape", "shape+prevtag",
	"suffix3", "word", "word+nextpos", "word.lower", "wordlen"}

// binaryMaxentClassifier is a feature encoding that generates vectors
// containing binary joint-features of the form:
//
//    |  joint_feat(fs, l) = { 1 if (fs[fname] == fval) and (l == label)
//    |                      {
//    |                      { 0 otherwise
//
// where `fname` is the name of an input-feature, `fval` is a value for that
// input-feature, and `label` is a label.
//
// See https://www.nltk.org/_modules/nltk/classify/maxent.html for more
// information.
type binaryMaxentClassifier struct {
	cardinality int
	labels      []string
	mapping     map[string]int
	weights     []float64
}

// newMaxentClassifier creates a new binaryMaxentClassifier from the provided
// input values.
func newMaxentClassifier(
	weights []float64,
	mapping map[string]int,
	labels []string) *binaryMaxentClassifier {

	set := mapset.NewSet()
	for label := range mapping {
		set.Add(strings.Split(label, "-")[0])
	}

	return &binaryMaxentClassifier{
		set.Cardinality() + 1,
		labels,
		mapping,
		weights}
}

// marshal saves the model to disk.
func (m *binaryMaxentClassifier) marshal(path string) error {
	folder := filepath.Join(path, "Maxent")
	err := os.Mkdir(folder, os.ModePerm)
	for i, entry := range []string{"labels", "mapping", "weights"} {
		component, _ := os.Create(filepath.Join(folder, entry+".gob"))
		encoder := gob.NewEncoder(component)
		if i == 0 {
			checkError(encoder.Encode(m.labels))
		} else if i == 1 {
			checkError(encoder.Encode(m.mapping))
		} else {
			checkError(encoder.Encode(m.weights))
		}
	}
	return err
}

// entityExtracter is a maximum entropy classifier.
//
// See https://www.nltk.org/_modules/nltk/classify/maxent.html for more
// information.
type entityExtracter struct {
	model *binaryMaxentClassifier
}

// newEntityExtracter creates a new entityExtracter using the default model.
func newEntityExtracter() *entityExtracter {
	var mapping map[string]int
	var weights []float64
	var labels []string

	dec := getAsset("Maxent", "mapping.gob")
	checkError(dec.Decode(&mapping))

	dec = getAsset("Maxent", "weights.gob")
	checkError(dec.Decode(&weights))

	dec = getAsset("Maxent", "labels.gob")
	checkError(dec.Decode(&labels))

	return &entityExtracter{model: newMaxentClassifier(weights, mapping, labels)}
}

// newTrainedEntityExtracter creates a new EntityExtracter using the given
// model.
func newTrainedEntityExtracter(model *binaryMaxentClassifier) *entityExtracter {
	return &entityExtracter{model: model}
}

// chunk finds named-entity "chunks" from the given, pre-labeled tokens.
func (e *entityExtracter) chunk(tokens []*Token) []Entity {
	entities := []Entity{}
	end := ""

	parts := []*Token{}
	idx := 0

	for _, tok := range tokens {
		label := tok.Label
		if (label != "O" && label != end) ||
			(idx > 0 && tok.Tag == parts[idx-1].Tag) ||
			(idx > 0 && tok.Tag == "CD" && parts[idx-1].Label != "O") {
			end = strings.Replace(label, "B", "I", 1)
			parts = append(parts, tok)
			idx++
		} else if (label == "O" && end != "") || label == end {
			// We've found the end of an entity.
			if label != "O" {
				parts = append(parts, tok)
			}
			entities = append(entities, coalesce(parts))

			end = ""
			parts = []*Token{}
			idx = 0
		}
	}

	return entities
}

func (m *binaryMaxentClassifier) encode(features map[string]string, label string) []encodedValue {
	encoding := []encodedValue{}
	for _, key := range featureOrder {
		val := features[key]
		entry := strings.Join([]string{key, val, label}, "-")
		if ret, found := m.mapping[entry]; found {
			encoding = append(encoding, encodedValue{
				key:   ret,
				value: 1})
		}
	}
	return encoding
}

func (m *binaryMaxentClassifier) encodeGIS(features map[string]string, label string) []encodedValue {
	encoding := m.encode(features, label)
	length := len(m.mapping)

	total := 0
	for _, v := range encoding {
		total += v.value
	}
	encoding = append(encoding, encodedValue{
		key:   length,
		value: m.cardinality - total})

	return encoding
}

func adjustPos(text string, start, end int) (int, int) {
	index, left, right := -1, 0, 0
	_ = strings.Map(func(r rune) rune {
		index++
		if unicode.IsSpace(r) {
			if index < start {
				left++
			}
			if index < end {
				right++
			}
			return -1
		}
		return r
	}, text)
	return start - left, end - right
}

func extractFeatures(tokens []*Token, history []string) []feature {
	features := make([]feature, len(tokens))
	for i := range tokens {
		features[i] = feature{
			label:    history[i],
			features: extract(i, tokens, history)}
	}
	return features
}

func assignLabels(tokens []*Token, entity *EntityContext) []string {
	history := make([]string, len(tokens))
	for i := range tokens {
		history[i] = "O"
	}

	if entity.Accept {
		for _, span := range entity.Spans {
			start, end := adjustPos(entity.Text, span.Start, span.End)
			index := 0
			for i, tok := range tokens {
				if index == start {
					history[i] = "B-" + span.Label
				} else if index > start && index < end {
					history[i] = "I-" + span.Label
				}
				index += len(tok.Text)
			}
		}
	}

	return history
}

func makeCorpus(data []EntityContext, tagger *perceptronTagger) featureSet {
	tokenizer := newIterTokenizer()
	corpus := featureSet{}
	for i := range data {
		entry := &data[i]
		tokens := tagger.tag(tokenizer.tokenize(entry.Text))
		history := assignLabels(tokens, entry)
		for _, element := range extractFeatures(tokens, history) {
			corpus = append(corpus, element)
		}
	}
	return corpus
}

func extracterFromData(data []EntityContext, tagger *perceptronTagger) *entityExtracter {
	corpus := makeCorpus(data, tagger)
	encoding := encode(corpus)
	cInv := 1.0 / float64(encoding.cardinality)

	empfreq := empiricalCount(corpus, encoding)
	rows, _ := empfreq.Dims()

	unattested := []int{}
	for index := 0; index < rows; index++ {
		if empfreq.At(index, 0) == 0.0 {
			unattested = append(unattested, index)
		}
		empfreq.SetVec(index, math.Log2(empfreq.At(index, 0)))
	}

	weights := make([]float64, rows)
	for _, idx := range unattested {
		weights[idx] = math.Inf(-1)
	}
	encoding.weights = weights

	classifier := newTrainedEntityExtracter(encoding)
	for index := 0; index < 100; index++ {
		est := estCount(classifier, corpus, encoding)
		for _, idx := range unattested {
			est.SetVec(idx, est.AtVec(idx)+1)
		}
		rows, _ := est.Dims()
		for index := 0; index < rows; index++ {
			est.SetVec(index, math.Log2(est.At(index, 0)))
		}
		weights = classifier.model.weights

		est.SubVec(empfreq, est)
		est.ScaleVec(cInv, est)

		for index := 0; index < len(weights); index++ {
			weights[index] += est.AtVec(index)
		}

		classifier.model.weights = weights
	}

	return classifier
}

func estCount(
	classifier *entityExtracter,
	corpus featureSet,
	encoder *binaryMaxentClassifier,
) *mat.VecDense {
	count := mat.NewVecDense(len(encoder.mapping)+1, nil)
	for _, entry := range corpus {
		pdist := classifier.probClassify(entry.features)
		for label := range pdist.dict {
			prob := pdist.prob(label)
			for _, enc := range encoder.encodeGIS(entry.features, label) {
				out := count.AtVec(enc.key) + (prob * float64(enc.value))
				count.SetVec(enc.key, out)
			}
		}
	}
	return count
}

func (e *entityExtracter) classify(tokens []*Token) []*Token {
	length := len(tokens)
	history := make([]string, 0, length)
	for i := 0; i < length; i++ {
		scores := make(map[string]float64)
		features := extract(i, tokens, history)
		for _, label := range e.model.labels {
			total := 0.0
			for _, encoded := range e.model.encode(features, label) {
				total += e.model.weights[encoded.key] * float64(encoded.value)
			}
			scores[label] = total
		}
		label := max(scores)
		tokens[i].Label = label
		history = append(history, simplePOS(label))
	}
	return tokens
}

func (e *entityExtracter) probClassify(features map[string]string) *mappedProbDist {
	scores := make(map[string]float64)
	for _, label := range e.model.labels {
		vec := e.model.encodeGIS(features, label)
		total := 0.0
		for _, entry := range vec {
			total += e.model.weights[entry.key] * float64(entry.value)
		}
		scores[label] = total
	}

	//&mappedProbDist{dict: scores, log: true}
	return newMappedProbDist(scores, true)
}

func parseEntities(ents []string) string {
	if stringInSlice("B-PERSON", ents) && len(ents) == 2 {
		// PERSON takes precedence because it's hard to identify.
		return "PERSON"
	}
	return strings.Split(ents[0], "-")[1]
}

func coalesce(parts []*Token) Entity {
	length := len(parts)
	labels := make([]string, length)
	tokens := make([]string, length)
	for i, tok := range parts {
		tokens[i] = tok.Text
		labels[i] = tok.Label
	}
	return Entity{
		Label: parseEntities(labels),
		Text:  strings.Join(tokens, " "),
	}
}

func extract(i int, ctx []*Token, history []string) map[string]string {
	feats := make(map[string]string)

	word := ctx[i].Text
	prevShape := "None"

	feats["bias"] = "True"
	feats["word"] = word
	feats["pos"] = ctx[i].Tag
	feats["en-wordlist"] = isBasic(word)
	feats["word.lower"] = strings.ToLower(word)
	feats["suffix3"] = nSuffix(word, 3)
	feats["prefix3"] = nPrefix(word, 3)
	feats["shape"] = shape(word)
	feats["wordlen"] = strconv.Itoa(len(word))

	if i == 0 {
		feats["prevtag"] = "None"
		feats["prevword"], feats["prevpos"] = "None", "None"
	} else if i == 1 {
		feats["prevword"] = strings.ToLower(ctx[i-1].Text)
		feats["prevpos"] = ctx[i-1].Tag
		feats["prevtag"] = history[i-1]
	} else {
		feats["prevword"] = strings.ToLower(ctx[i-1].Text)
		feats["prevpos"] = ctx[i-1].Tag
		feats["prevtag"] = history[i-1]
		prevShape = shape(ctx[i-1].Text)
	}

	if i == len(ctx)-1 {
		feats["nextword"], feats["nextpos"] = "None", "None"
	} else {
		feats["nextword"] = strings.ToLower(ctx[i+1].Text)
		feats["nextpos"] = strings.ToLower(ctx[i+1].Tag)
	}

	feats["word+nextpos"] = strings.Join(
		[]string{feats["word.lower"], feats["nextpos"]}, "+")
	feats["pos+prevtag"] = strings.Join(
		[]string{feats["pos"], feats["prevtag"]}, "+")
	feats["shape+prevtag"] = strings.Join(
		[]string{prevShape, feats["prevtag"]}, "+")

	return feats
}

func shape(word string) string {
	if isNumeric(word) {
		return "number"
	} else if match, _ := regexp.MatchString(`\W+$`, word); match {
		return "punct"
	} else if match, _ := regexp.MatchString(`\w+$`, word); match {
		if strings.ToLower(word) == word {
			return "downcase"
		} else if strings.Title(word) == word {
			return "upcase"
		} else {
			return "mixedcase"
		}
	}
	return "other"
}

func simplePOS(pos string) string {
	if strings.HasPrefix(pos, "V") {
		return "v"
	}
	return strings.Split(pos, "-")[0]
}

func encode(corpus featureSet) *binaryMaxentClassifier {
	mapping := make(map[string]int) // maps (fname-fval-label) -> fid
	count := make(map[string]int)   // maps (fname, fval) -> count
	weights := []float64{}

	labels := []string{}
	for _, entry := range corpus {
		label := entry.label
		if !stringInSlice(label, labels) {
			labels = append(labels, label)
		}

		for _, fname := range featureOrder {
			fval := entry.features[fname]
			key := strings.Join([]string{fname, fval}, "-")
			count[key]++
			entry := strings.Join([]string{fname, fval, label}, "-")
			if _, found := mapping[entry]; !found {
				mapping[entry] = len(mapping)
			}

		}
	}
	return newMaxentClassifier(weights, mapping, labels)
}

func empiricalCount(corpus featureSet, encoding *binaryMaxentClassifier) *mat.VecDense {
	count := mat.NewVecDense(len(encoding.mapping)+1, nil)
	for _, entry := range corpus {
		for _, encoded := range encoding.encodeGIS(entry.features, entry.label) {
			idx := encoded.key
			count.SetVec(idx, count.AtVec(idx)+float64(encoded.value))
		}
	}
	return count
}

func addLogs(x, y float64) float64 {
	if x < y+maxLogDiff {
		return y
	} else if y < x+maxLogDiff {
		return x
	}
	base := math.Min(x, y)
	return base + math.Log2(math.Pow(2, x-base)+math.Pow(2, y-base))
}

func sumLogs(logs []float64) float64 {
	if len(logs) == 0 {
		return math.Inf(-1)
	}
	sum := logs[0]
	for _, log := range logs[1:] {
		sum = addLogs(sum, log)
	}
	return sum
}

package prose

import (
	"os"
	"path/filepath"
)

// A Model holds the structures and data used internally by prose.
type Model struct {
	Name string

	tagger    *perceptronTagger
	extracter *entityExtracter
}

// DataSource provides training data to a Model.
type DataSource func(model *Model)

// UsingEntities creates a NER from labeled data.
func UsingEntities(data []EntityContext) DataSource {
	return func(model *Model) {
		model.extracter = extracterFromData(data, model.tagger)
	}
}

// LabeledEntity represents an externally-labeled named-entity.
type LabeledEntity struct {
	Start int
	End   int
	Label string
}

// EntityContext represents text containing named-entities.
type EntityContext struct {
	// Is this is a correct entity?
	//
	// Some annotation software, e.g. Prodigy, include entities "rejected" by
	// its user. This allows us to handle those cases.
	Accept bool

	Spans []LabeledEntity // The entity locations relative to `Text`.
	Text  string          // The sentence containing the entities.
}

// ModelFromData creates a new Model from user-provided training data.
func ModelFromData(name string, sources ...DataSource) *Model {
	model := defaultModel(true, true)
	model.Name = name
	for _, source := range sources {
		source(model)
	}
	return model
}

// ModelFromDisk loads a Model from the user-provided location.
func ModelFromDisk(path string) *Model {
	name, classifier := loadClassifier(path)
	return &Model{
		Name: name,

		extracter: classifier,
		tagger:    newPerceptronTagger()}
}

// Write saves a Model to the user-provided location.
func (m *Model) Write(path string) error {
	err := os.MkdirAll(path, os.ModePerm)
	// m.Tagger.model.Marshal(path)
	checkError(m.extracter.model.marshal(path))
	return err
}

/* TODO: External taggers
func loadTagger(path string) *perceptronTagger {
	var wts map[string]map[string]float64
	var tags map[string]string
	var classes []string

	loc := filepath.Join(path, "AveragedPerceptron")
	dec := getDiskAsset(filepath.Join(loc, "weights.gob"))
	checkError(dec.Decode(&wts))

	dec = getDiskAsset(filepath.Join(loc, "tags.gob"))
	checkError(dec.Decode(&tags))

	dec = getDiskAsset(filepath.Join(loc, "classes.gob"))
	checkError(dec.Decode(&classes))

	model := newAveragedPerceptron(wts, tags, classes)
	return newTrainedPerceptronTagger(model)
}*/

func loadClassifier(path string) (string, *entityExtracter) {
	var mapping map[string]int
	var weights []float64
	var labels []string

	loc := filepath.Join(path, "Maxent")
	dec := getDiskAsset(filepath.Join(loc, "mapping.gob"))
	checkError(dec.Decode(&mapping))

	dec = getDiskAsset(filepath.Join(loc, "weights.gob"))
	checkError(dec.Decode(&weights))

	dec = getDiskAsset(filepath.Join(loc, "labels.gob"))
	checkError(dec.Decode(&labels))

	model := newMaxentClassifier(weights, mapping, labels)
	name := filepath.Base(path)
	return name, newTrainedEntityExtracter(model)
}

func defaultModel(tagging, classifying bool) *Model {
	var tagger *perceptronTagger
	var classifier *entityExtracter

	if tagging || classifying {
		tagger = newPerceptronTagger()
	}
	if classifying {
		classifier = newEntityExtracter()
	}

	return &Model{
		Name: "en-v2.0.0",

		tagger:    tagger,
		extracter: classifier,
	}
}

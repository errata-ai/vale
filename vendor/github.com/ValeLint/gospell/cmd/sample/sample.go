package main

import (
	"github.com/naoina/toml"
	glob "github.com/ryanuber/go-glob"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strings"

	"github.com/client9/gospell"
	"github.com/client9/gospell/plaintext"
)

// Dictionary is the configuration structure
type Dictionary struct {
	Language string   `json:"language"` // core dictionary
	Extra    []string // extra word packs
	//Wordlist  []string // personal word list files
	Additions []string // inline word additions
	Removals  []string

	FileSet []DictionaryFileSet `json:"fileset"`
}

// FileSet represents options to select or exclude a group of files
type FileSet struct {
	Path    string
	Include []string
	Exclude []string

	Matches []string
}

// DictionaryFileSet extends FileSet to include other information ont
// the file type
type DictionaryFileSet struct {
	FileSet
	Charset      string
	Source       string
	TemplateType string
}

func (fs *FileSet) visit(path string, info os.FileInfo, err error) error {
	if err != nil {
		log.Printf("visitor failed on %q: %s", path, err)
		return nil
	}
	included := false
	for _, inc := range fs.Include {
		if glob.Glob(inc, path) {
			included = true
			break
		}
	}
	excluded := false
	for _, exc := range fs.Exclude {
		if strings.Index(path, exc) != -1 {
			excluded = true
			break
		}
	}
	if included && !excluded && !info.IsDir() {
		fs.Matches = append(fs.Matches, path)
		//log.Printf("path allowed: %q", path)
		return nil
	}
	if !included && !excluded {
		//log.Printf("path ignored: %q", path)
		return nil
	}
	if excluded && info.IsDir() {
		//log.Printf("path ignoring directory %q", path)
		return filepath.SkipDir
	}
	//log.Printf("Included then excluded: %q", path)
	return nil
}

func main() {
	config, err := ioutil.ReadFile(".spelling.toml")
	if err != nil {
		log.Fatalf("Unable to reading config: %s", err)
	}
	//log.Printf("JSON: %s", cson.ToJSON([]byte(config)))
	s := Dictionary{}
	err = toml.Unmarshal([]byte(config), &s)
	if err != nil {
		log.Printf("out : %+v", s)
		log.Fatalf("err = %v", err)
	}
	if s.Language == "" {
		s.Language = "en_US"
	}
	if s.Language != "en_US" {
		log.Fatalf("Only support en_US: got %q", s.Language)
	}
	gs, err := gospell.NewGoSpell("/usr/local/share/hunspell/en_US.aff", "/usr/local/share/hunspell/en_US.dic")
	if err != nil {
		log.Fatalf("Unable to load dictionary: %s", err)
	}

	for _, wordfile := range s.Extra {
		_, err := gs.AddWordListFile(wordfile)
		if err != nil {
			log.Printf("Unable to read word list %s: %s", wordfile, err)
		}
	}

	for _, word := range s.Additions {
		log.Printf("Adding %q", word)
		gs.AddWordRaw(word)
	}

	if len(s.FileSet) == 0 {
		s.FileSet = append(s.FileSet, DictionaryFileSet{
			FileSet: FileSet{
				Path:    ".",
				Include: []string{"*"},
				Exclude: []string{".git"},
			},
		})
	}
	finalExit := 0
	for _, fs := range s.FileSet {
		if fs.Path == "" {
			fs.Path = "."
		}
		filepath.Walk(fs.Path, fs.visit)
		for _, filename := range fs.Matches {
			raw, err := ioutil.ReadFile(filename)
			if err != nil {
				log.Printf("Unable to read %q: %s", filename, err)
				finalExit = finalExit | 2
				continue
			}
			pt, err := plaintext.ExtractorByFilename(filename)
			if err != nil {
				continue
			}
			out := gospell.SpellFile(gs, pt, raw)
			for _, diff := range out {
				diff.Filename = filepath.Base(filename)
				diff.Path = filename
				finalExit = finalExit | 1
				log.Printf("Got a %s:%d %s", diff.Path, diff.LineNum, diff.Original)
			}
		}
	}
	os.Exit(finalExit)
}

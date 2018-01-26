package main

import (
	"bytes"
	"flag"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"text/template"
	"time"

	"github.com/client9/gospell"
	"github.com/client9/gospell/plaintext"
)

var (
	stdout      *log.Logger // see below in init()
	defaultLog  *template.Template
	defaultWord *template.Template
	defaultLine *template.Template
)

const (
	defaultLogTmpl  = `{{ .Path }}:{{ .LineNum }}:{{ js .Original }}`
	defaultWordTmpl = `{{ .Original }}`
	defaultLineTmpl = `{{ .Line }}`
)

func init() {
	// we see it so it doesn't use a prefix or include a time stamp.
	stdout = log.New(os.Stdout, "", 0)
	defaultLog = template.Must(template.New("defaultLog").Parse(defaultLogTmpl))
	defaultWord = template.Must(template.New("defaultWord").Parse(defaultWordTmpl))
	defaultLine = template.Must(template.New("defaultLine").Parse(defaultLineTmpl))
}

func main() {
	format := flag.String("f", "", "use Golang template for log message")
	listOnly := flag.Bool("l", false, "only print unknown word")
	lineOnly := flag.Bool("L", false, "print line with unknown word")

	// TODO based on OS (Windows vs. Linux)
	dictPath := flag.String("path", ".:/usr/local/share/hunspell:/usr/share/hunspell", "Search path for dictionaries")

	// TODO based on environment variable settings
	dicts := flag.String("d", "en_US", "dictionaries to load")

	personalDict := flag.String("p", "", "personal wordlist file")

	flag.Parse()
	args := flag.Args()

	if *listOnly {
		defaultLog = defaultWord
	}

	if *lineOnly {
		defaultLog = defaultLine
	}

	if len(*format) > 0 {
		t, err := template.New("custom").Parse(*format)
		if err != nil {
			log.Fatalf("Unable to compile log format: %s", err)
		}
		defaultLog = t
	}

	affFile := ""
	dicFile := ""
	for _, base := range filepath.SplitList(*dictPath) {
		affFile = filepath.Join(base, *dicts+".aff")
		dicFile = filepath.Join(base, *dicts+".dic")
		//log.Printf("Trying %s", affFile)
		_, err1 := os.Stat(affFile)
		_, err2 := os.Stat(dicFile)
		if err1 == nil && err2 == nil {
			break
		}
		affFile = ""
		dicFile = ""
	}

	if affFile == "" {
		log.Fatalf("Unable to load %s", *dicts)
	}

	log.Printf("Loading %s %s", affFile, dicFile)
	timeStart := time.Now()
	h, err := gospell.NewGoSpell(affFile, dicFile)
	timeEnd := time.Now()

	// note: 10x too slow
	log.Printf("Loaded in %v", timeEnd.Sub(timeStart))
	if err != nil {
		log.Fatalf("%s", err)
	}

	if *personalDict != "" {
		raw, err := ioutil.ReadFile(*personalDict)
		if err != nil {
			log.Fatalf("Unable to load personal dictionary %s: %s", *personalDict, err)
		}
		duplicates, err := h.AddWordList(bytes.NewReader(raw))
		if err != nil {
			log.Fatalf("Unable to process personal dictionary %s: %s", *personalDict, err)
		}
		if len(duplicates) > 0 {
			for _, word := range duplicates {
				log.Printf("Word %q in personal dictionary already exists in main dictionary", word)
			}
		}
	}

	// stdin support
	if len(args) == 0 {
		raw, err := ioutil.ReadAll(os.Stdin)
		if err != nil {
			log.Fatalf("Unable to read Stdin: %s", err)
		}
		pt, _ := plaintext.NewIdentity()
		out := gospell.SpellFile(h, pt, raw)
		for _, diff := range out {
			diff.Filename = "stdin"
			diff.Path = ""
			buf := bytes.Buffer{}
			defaultLog.Execute(&buf, diff)
			// goroutine-safe print to os.Stdout
			stdout.Println(buf.String())
		}
	}
	for _, arg := range args {
		// ignore directories
		if f, err := os.Stat(arg); err != nil || f.IsDir() {
			continue
		}

		raw, err := ioutil.ReadFile(arg)
		if err != nil {
			log.Fatalf("Unable to read %q: %s", arg, err)
		}
		pt, err := plaintext.ExtractorByFilename(arg)
		if err != nil {
			continue
		}
		out := gospell.SpellFile(h, pt, raw)
		for _, diff := range out {
			diff.Filename = filepath.Base(arg)
			diff.Path = arg
			buf := bytes.Buffer{}
			defaultLog.Execute(&buf, diff)
			// goroutine-safe print to os.Stdout
			stdout.Println(buf.String())
		}
	}
}

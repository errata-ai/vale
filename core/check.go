package core

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/ValeLint/vale/rule"
	"github.com/ValeLint/vale/util"
	"github.com/mitchellh/mapstructure"
	"gopkg.in/yaml.v2"
)

// AllChecks holds all of our individual checks. The keys are in the form
// "styleName.checkName".
var AllChecks = map[string]check{}

const (
	ignoreCase      = `(?i)`
	wordTemplate    = `\b(?:%s)\b`
	nonwordTemplate = `(?:%s)`
)

type ruleFn func(string, *File) []Alert

// A check implements a single rule.
type check struct {
	extends string
	level   int
	rule    ruleFn
	scope   Selector
}

// Definition holds the common attributes of rule definitions.
type Definition struct {
	Description string
	Extends     string
	Level       string
	Link        string
	Message     string
	Name        string
	Scope       string
}

// Existence checks for the present of Tokens.
type Existence struct {
	Definition `mapstructure:",squash"`
	Ignorecase bool
	Nonword    bool
	Raw        []string
	Tokens     []string
}

// Substitution switches the values of Swap for its keys.
type Substitution struct {
	Definition `mapstructure:",squash"`
	Ignorecase bool
	Nonword    bool
	Swap       map[string]string
}

// Occurrence counts the number of times Token appears.
type Occurrence struct {
	Definition `mapstructure:",squash"`
	Max        int
	Token      string
}

// Repetition looks for repeated uses of Tokens.
type Repetition struct {
	Definition `mapstructure:",squash"`
	Max        int
	Ignorecase bool
	Tokens     []string
}

// Consistency ensures that the keys and values of Either don't both exist.
type Consistency struct {
	Definition `mapstructure:",squash"`
	Nonword    bool
	Ignorecase bool
	Either     map[string]string
}

// Conditional ensures that the present of First ensures the present of Second.
type Conditional struct {
	Definition `mapstructure:",squash"`
	Ignorecase bool
	First      string
	Second     string
	Exceptions []string
}

// Script runs Exe with Runtime.
type Script struct {
	Definition `mapstructure:",squash"`
	Exe        string
	Runtime    string
}

var defaultChecks = []string{
	"Abbreviations",
	"Annotations",
	"ComplexWords",
	"Editorializing",
	"GenderBias",
	"Hedging",
	"Litotes",
	"PassiveVoice",
	"Redundancy",
	"Repetition",
	"Uncomparables",
	"Wordiness",
}

var extensionPoints = []string{
	"capitalization",
	"conditional",
	"consistency",
	"existence",
	"occurrence",
	"repetition",
	"script",
	"substitution",
}

func init() {
	var style, path string

	loadedStyles := []string{}
	loadDefaultChecks()
	if util.Config.StylesPath == "" {
		return
	}

	loadedStyles = append(loadedStyles, "vale")
	baseDir := util.Config.StylesPath
	for _, style = range util.Config.GBaseStyles {
		if style == "vale" {
			continue
		}
		loadExternalStyle(filepath.Join(baseDir, style))
		loadedStyles = append(loadedStyles, style)
	}

	for _, styles := range util.Config.SBaseStyles {
		for _, style := range styles {
			if !util.StringInSlice(style, loadedStyles) {
				loadExternalStyle(filepath.Join(baseDir, style))
				loadedStyles = append(loadedStyles, style)
			}
		}
	}

	for _, chk := range util.Config.Checks {
		if !strings.Contains(chk, ".") {
			continue
		}
		check := strings.Split(chk, ".")
		if !util.StringInSlice(check[0], loadedStyles) {
			fName := check[1] + ".yml"
			path = filepath.Join(baseDir, check[0], fName)
			loadCheck(fName, path)
		}
	}
}

func cleanText(ext string, txt string) string {
	regex := `((?:https?|ftp)://[^\s/$.?#].[^\s]*)`
	if s, ok := util.MatchIgnoreByByExtension[ext]; ok {
		regex += `|` + s
	}

	inline := regexp.MustCompile(regex)
	for _, s := range inline.FindAllString(txt, -1) {
		txt = strings.Replace(txt, s, strings.Repeat("*", len(s)), -1)
	}

	return txt
}

func formatMessages(msg string, desc string, subs ...string) (string, string) {
	return util.FormatMessage(msg, subs...), util.FormatMessage(desc, subs...)
}

func makeAlert(chk Definition, loc []int, txt string) Alert {
	a := Alert{Check: chk.Name, Severity: chk.Level, Span: loc, Link: chk.Link}
	a.Message, a.Description = formatMessages(chk.Message, chk.Description,
		txt[loc[0]:loc[1]])
	return a
}

func checkConditional(txt string, chk Conditional, f *File, r []*regexp.Regexp) []Alert {
	alerts := []Alert{}
	txt = cleanText(f.NormedExt, txt)

	definitions := r[0].FindAllStringSubmatch(txt, -1)
	for _, def := range definitions {
		if len(def) > 1 {
			f.Sequences = append(f.Sequences, def[1])
		}
	}

	locs := r[1].FindAllStringIndex(txt, -1)
	if locs != nil {
		for _, loc := range locs {
			s := txt[loc[0]:loc[1]]
			if !util.StringInSlice(s, f.Sequences) && !util.StringInSlice(s, chk.Exceptions) {
				alerts = append(alerts, makeAlert(chk.Definition, loc, txt))
			}
		}
	}
	return alerts
}

func checkExistence(txt string, chk Existence, f *File, r *regexp.Regexp) []Alert {
	alerts := []Alert{}
	locs := r.FindAllStringIndex(cleanText(f.NormedExt, txt), -1)
	if locs != nil {
		for _, loc := range locs {
			alerts = append(alerts, makeAlert(chk.Definition, loc, txt))
		}
	}
	return alerts
}

func checkOccurrence(txt string, chk Occurrence, f *File, r *regexp.Regexp, lim int) []Alert {
	var loc []int

	alerts := []Alert{}
	locs := r.FindAllStringIndex(cleanText(f.NormedExt, txt), -1)
	occurrences := len(locs)
	if occurrences > lim {
		loc = []int{locs[0][0], locs[occurrences-1][1]}
		a := Alert{Check: chk.Name, Severity: chk.Level, Span: loc,
			Link: chk.Link}
		a.Message = chk.Message
		a.Description = chk.Description
		alerts = append(alerts, a)
	}

	return alerts
}

func checkRepetition(txt string, chk Repetition, f *File, r *regexp.Regexp) []Alert {
	var curr, prev string
	var ploc []int
	var hit bool
	var count int

	alerts := []Alert{}
	for _, loc := range r.FindAllStringIndex(txt, -1) {
		curr = strings.TrimSpace(txt[loc[0]:loc[1]])
		hit = curr == prev && curr != ""
		if hit {
			count++
		}
		if hit && count > chk.Max {
			floc := []int{ploc[0], loc[1]}
			a := Alert{Check: chk.Name, Severity: chk.Level, Span: floc,
				Link: chk.Link}
			a.Message, a.Description = formatMessages(chk.Message,
				chk.Description, curr)
			alerts = append(alerts, a)
			count = 0
		}
		ploc = loc
		prev = curr
	}
	return alerts
}

func checkSubstitution(txt string, chk Substitution, f *File, r *regexp.Regexp, repl []string) []Alert {
	alerts := []Alert{}
	if !r.MatchString(txt) {
		return alerts
	}

	txt = cleanText(f.NormedExt, txt)
	for _, submat := range r.FindAllStringSubmatchIndex(txt, -1) {
		for idx, mat := range submat {
			if mat != -1 && idx > 0 && idx%2 == 0 {
				loc := []int{mat, submat[idx+1]}
				a := Alert{Check: chk.Name, Severity: chk.Level, Span: loc,
					Link: chk.Link}
				a.Message, a.Description = formatMessages(chk.Message,
					chk.Description, repl[(idx/2)-1], txt[loc[0]:loc[1]])
				alerts = append(alerts, a)
			}
		}
	}

	return alerts
}

func checkConsistency(txt string, chk Consistency, f *File, r *regexp.Regexp, opts []string) []Alert {
	alerts := []Alert{}
	loc := []int{}
	txt = cleanText(f.NormedExt, txt)

	matches := r.FindAllStringSubmatchIndex(txt, -1)
	for _, submat := range matches {
		for idx, mat := range submat {
			if mat != -1 && idx > 0 && idx%2 == 0 {
				loc = []int{mat, submat[idx+1]}
				f.Sequences = append(f.Sequences, r.SubexpNames()[idx/2])
			}
		}
	}

	if matches != nil && util.AllStringsInSlice(opts, f.Sequences) {
		chk.Name = chk.Extends
		alerts = append(alerts, makeAlert(chk.Definition, loc, txt))
	}
	return alerts
}

func checkScript(txt string, chkDef Script, exe string, f *File) []Alert {
	alerts := []Alert{}
	cmd := exec.Command(chkDef.Runtime, exe, txt)
	out, err := cmd.Output()
	if util.CheckError(err, exe) {
		merr := json.Unmarshal(out, &alerts)
		util.CheckError(merr, exe)
	}
	return alerts
}

func addScriptCheck(chkName string, chkDef Script) {
	style := strings.Split(chkName, ".")[0]
	exe := filepath.Join(util.Config.StylesPath, style, "scripts", chkDef.Exe)
	if util.FileExists(exe) {
		fn := func(text string, file *File) []Alert {
			return checkScript(text, chkDef, exe, file)
		}
		updateAllChecks(chkDef.Definition, fn)
	}
}

func addConsistencyCheck(chkName string, chkDef Consistency) {
	var chkRE string

	regex := ""
	if chkDef.Ignorecase {
		regex += ignoreCase
	}
	if !chkDef.Nonword {
		regex += wordTemplate
	} else {
		regex += nonwordTemplate
	}

	count := 0
	chkKey := strings.Split(chkName, ".")[1]
	for v1, v2 := range chkDef.Either {
		count += 2
		subs := []string{
			fmt.Sprintf("%s%d", chkKey, count), fmt.Sprintf("%s%d", chkKey, count+1)}

		chkRE = fmt.Sprintf("(?P<%s>%s)|(?P<%s>%s)", subs[0], v1, subs[1], v2)
		chkRE = fmt.Sprintf(regex, chkRE)
		re, err := regexp.Compile(chkRE)
		if util.CheckError(err, chkName) {
			chkDef.Extends = chkName
			chkDef.Name = fmt.Sprintf("%s.%s", chkName, v1)
			fn := func(text string, file *File) []Alert {
				return checkConsistency(text, chkDef, file, re, subs)
			}
			updateAllChecks(chkDef.Definition, fn)
		}
	}
}

func addExistenceCheck(chkName string, chkDef Existence) {
	regex := ""
	if chkDef.Ignorecase {
		regex += ignoreCase
	}

	regex += strings.Join(chkDef.Raw, "")
	if !chkDef.Nonword && len(chkDef.Tokens) > 0 {
		regex += wordTemplate
	} else {
		regex += nonwordTemplate
	}

	regex = fmt.Sprintf(regex, strings.Join(chkDef.Tokens, "|"))
	re, err := regexp.Compile(regex)
	if util.CheckError(err, chkName) {
		fn := func(text string, file *File) []Alert {
			return checkExistence(text, chkDef, file, re)
		}
		updateAllChecks(chkDef.Definition, fn)
	}
}

func addRepetitionCheck(chkName string, chkDef Repetition) {
	regex := ""
	if chkDef.Ignorecase {
		regex += ignoreCase
	}
	regex += `(` + strings.Join(chkDef.Tokens, "|") + `)`
	re, err := regexp.Compile(regex)
	if util.CheckError(err, chkName) {
		fn := func(text string, file *File) []Alert {
			return checkRepetition(text, chkDef, file, re)
		}
		updateAllChecks(chkDef.Definition, fn)
	}
}

func addOccurrenceCheck(chkName string, chkDef Occurrence) {
	re, err := regexp.Compile(chkDef.Token)
	if util.CheckError(err, chkName) && chkDef.Max >= 1 {
		fn := func(text string, file *File) []Alert {
			return checkOccurrence(text, chkDef, file, re, chkDef.Max)
		}
		updateAllChecks(chkDef.Definition, fn)
	}
}

func addConditionalCheck(chkName string, chkDef Conditional) {
	var re *regexp.Regexp
	var expression []*regexp.Regexp
	var err error

	re, err = regexp.Compile(chkDef.Second)
	if !util.CheckError(err, chkName) {
		return
	}
	expression = append(expression, re)

	re, err = regexp.Compile(chkDef.First)
	if !util.CheckError(err, chkName) {
		return
	}
	expression = append(expression, re)

	fn := func(text string, file *File) []Alert {
		return checkConditional(text, chkDef, file, expression)
	}
	updateAllChecks(chkDef.Definition, fn)
}

func addSubstitutionCheck(chkName string, chkDef Substitution) {
	regex := ""
	tokens := ""

	if chkDef.Ignorecase {
		regex += ignoreCase
	}
	if !chkDef.Nonword {
		regex += wordTemplate
	} else {
		regex += nonwordTemplate
	}

	replacements := []string{}
	for regexstr, replacement := range chkDef.Swap {
		if strings.Count(regexstr, "(") != strings.Count(regexstr, "?:") {
			continue
		}
		tokens += `(` + regexstr + `)|`
		replacements = append(replacements, replacement)
	}

	regex = fmt.Sprintf(regex, strings.TrimRight(tokens, "|"))
	re, err := regexp.Compile(regex)
	if util.CheckError(err, "addSubstitutionCheck") {
		fn := func(text string, file *File) []Alert {
			return checkSubstitution(text, chkDef, file, re, replacements)
		}
		updateAllChecks(chkDef.Definition, fn)
	}
}

func updateAllChecks(chkDef Definition, fn ruleFn) {
	chk := check{rule: fn, extends: chkDef.Extends}
	chk.level = util.LevelToInt[chkDef.Level]
	chk.scope = Selector{Value: chkDef.Scope}
	AllChecks[chkDef.Name] = chk
}

func addCheck(file []byte, chkName string) {
	var extends string

	// Load the rule definition.
	generic := map[string]interface{}{}
	err := yaml.Unmarshal(file, &generic)
	if !util.CheckError(err, chkName) {
		return
	}

	// Ensure that we're given an extension point.
	if point, ok := generic["extends"]; !ok {
		return
	} else if !util.StringInSlice(point.(string), extensionPoints) {
		return
	} else {
		extends = point.(string)
	}

	// Set default values, if necessary.
	generic["name"] = chkName
	if _, ok := generic["level"]; !ok {
		generic["level"] = "suggestion"
	}
	if _, ok := generic["scope"]; !ok {
		generic["scope"] = "text"
	}

	// Create and add the rule.
	if extends == "existence" {
		def := Existence{}
		if err := mapstructure.Decode(generic, &def); err == nil {
			addExistenceCheck(chkName, def)
		}
	} else if extends == "substitution" {
		def := Substitution{}
		if err := mapstructure.Decode(generic, &def); err == nil {
			addSubstitutionCheck(chkName, def)
		}
	} else if extends == "occurrence" {
		def := Occurrence{}
		if err := mapstructure.Decode(generic, &def); err == nil {
			addOccurrenceCheck(chkName, def)
		}
	} else if extends == "repetition" {
		def := Repetition{}
		if err := mapstructure.Decode(generic, &def); err == nil {
			addRepetitionCheck(chkName, def)
		}
	} else if extends == "consistency" {
		def := Consistency{}
		if err := mapstructure.Decode(generic, &def); err == nil {
			addConsistencyCheck(chkName, def)
		}
	} else if extends == "conditional" {
		def := Conditional{}
		if err := mapstructure.Decode(generic, &def); err == nil {
			addConditionalCheck(chkName, def)
		}
	} else if extends == "script" {
		def := Script{}
		if err := mapstructure.Decode(generic, &def); err == nil {
			addScriptCheck(chkName, def)
		}
	}
}

func loadExternalStyle(path string) {
	err := filepath.Walk(path,
		func(fp string, fi os.FileInfo, err error) error {
			if err != nil || fi.IsDir() {
				return nil
			}
			loadCheck(fi.Name(), fp)
			return nil
		})
	util.CheckError(err, path)
}

func loadCheck(fName string, fp string) {
	if strings.HasSuffix(fName, ".yml") {
		f, err := ioutil.ReadFile(fp)
		if !util.CheckError(err, fName) {
			return
		}

		style := filepath.Base(filepath.Dir(fp))
		chkName := style + "." + strings.Split(fName, ".")[0]
		if _, ok := AllChecks[chkName]; ok {
			fmt.Printf("error (%s): duplicate check\n", chkName)
			return
		}

		addCheck(f, chkName)
	}
}

func loadDefaultChecks() {
	for _, chk := range defaultChecks {
		b, err := rule.Asset("rule/" + chk + ".yml")
		if err != nil {
			continue
		}
		addCheck(b, "vale."+chk)
	}
}

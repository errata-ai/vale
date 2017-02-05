package lint

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/jdkato/txtlint/rule"
	"github.com/jdkato/txtlint/util"
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
	level int
	rule  ruleFn
	scope Selector
}

// A definition defines a rule from an external file.
type definition struct {
	Exceptions []string
	Exe        string
	If         string
	Ignorecase bool
	Level      string
	Map        map[string]string
	Max        int
	Message    string
	Negate     bool
	Nonword    bool
	Raw        []string
	Runtime    string
	Scope      string
	Then       string
	Tokens     []string
	Type       string
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

var typeToFunc = map[string]func(string, definition){
	"conditional":  addConditionalCheck,
	"consistency":  addConsistencyCheck,
	"existence":    addExistenceCheck,
	"occurrence":   addOccurrenceCheck,
	"repetition":   addRepetitionCheck,
	"script":       addScriptCheck,
	"substitution": addSubstitutionCheck,
}

func init() {
	var style, path string

	loadedStyles := []string{}
	loadDefaultChecks()
	if util.Config.StylesPath == "" {
		return
	}

	loadedStyles = append(loadedStyles, "txtlint")
	baseDir := util.Config.StylesPath
	for _, style = range util.Config.GBaseStyles {
		if style == "txtlint" {
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
			path = filepath.Join(baseDir, check[0], check[1]+".yml")
			loadCheck(check[1], path)
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

func conditional(txt string, chk definition, f *File, r []*regexp.Regexp) []Alert {
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
				a := Alert{Check: chk.Type, Severity: chk.Level, Span: loc}
				a.Message = fmt.Sprintf(chk.Message, txt[loc[0]:loc[1]])
				alerts = append(alerts, a)
			}
		}
	}
	return alerts
}

func existence(txt string, chk definition, f *File, r *regexp.Regexp) []Alert {
	alerts := []Alert{}
	locs := r.FindAllStringIndex(cleanText(f.NormedExt, txt), -1)
	if locs != nil {
		for _, loc := range locs {
			a := Alert{Check: chk.Type, Severity: chk.Level, Span: loc}
			a.Message = fmt.Sprintf(chk.Message, txt[loc[0]:loc[1]])
			alerts = append(alerts, a)
		}
	}
	return alerts
}

func occurrence(txt string, chk definition, f *File, r *regexp.Regexp, lim int) []Alert {
	var loc []int

	alerts := []Alert{}
	locs := r.FindAllStringIndex(cleanText(f.NormedExt, txt), -1)
	occurrences := len(locs)
	if occurrences > lim {
		if len(locs) > 1 {
			loc = []int{locs[0][0], locs[1][1]}
		} else {
			loc = []int{locs[0][0], locs[0][1]}
		}
		a := Alert{Check: chk.Type, Severity: chk.Level, Span: loc}
		a.Message = chk.Message
		alerts = append(alerts, a)
	}

	return alerts
}

func repetition(txt string, chk definition, f *File, r *regexp.Regexp) []Alert {
	var curr, prev string
	var ploc []int

	alerts := []Alert{}
	for _, loc := range r.FindAllStringIndex(txt, -1) {
		curr = strings.TrimSpace(txt[loc[0]:loc[1]])
		if chk.Ignorecase {
			curr = strings.ToLower(curr)
		}
		if curr == prev && curr != "" {
			floc := []int{ploc[0], loc[1]}
			a := Alert{Check: chk.Type, Severity: chk.Level, Span: floc}
			a.Message = fmt.Sprintf(chk.Message, curr)
			alerts = append(alerts, a)
		}
		ploc = loc
		prev = curr
	}
	return alerts
}

func substitution(txt string, chk definition, f *File, r *regexp.Regexp, repl []string) []Alert {
	alerts := []Alert{}
	if !r.MatchString(txt) {
		return alerts
	}

	txt = cleanText(f.NormedExt, txt)
	for _, submat := range r.FindAllStringSubmatchIndex(txt, -1) {
		for idx, mat := range submat {
			if mat != -1 && idx > 0 && idx%2 == 0 {
				loc := []int{mat, submat[idx+1]}
				a := Alert{Check: chk.Type, Severity: chk.Level, Span: loc}
				if strings.Count(chk.Message, "%s") == 1 {
					a.Message = fmt.Sprintf(chk.Message, repl[(idx/2)-1])
				} else {
					a.Message = fmt.Sprintf(
						chk.Message, repl[(idx/2)-1], txt[loc[0]:loc[1]],
					)
				}
				alerts = append(alerts, a)
			}
		}
	}

	return alerts
}

func consistency(txt string, chk definition, f *File, r *regexp.Regexp, opts []string) []Alert {
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
		a := Alert{Check: chk.Type, Severity: chk.Level, Span: loc}
		a.Message = fmt.Sprintf(chk.Message, txt[loc[0]:loc[1]])
		alerts = append(alerts, a)
	}
	return alerts
}

func script(txt string, chkDef definition, exe string, f *File) []Alert {
	alerts := []Alert{}
	cmd := exec.Command(chkDef.Runtime, exe, txt)
	out, err := cmd.Output()
	if util.CheckError(err, exe) {
		merr := json.Unmarshal(out, &alerts)
		util.CheckError(merr, exe)
	}
	return alerts
}

func addScriptCheck(chkName string, chkDef definition) {
	chkDef.Type = chkName
	style := strings.Split(chkName, ".")[0]
	exe := filepath.Join(util.Config.StylesPath, style, "scripts", chkDef.Exe)
	if util.FileExists(exe) {
		fn := func(text string, file *File) []Alert {
			return script(text, chkDef, exe, file)
		}
		updateAllChecks(chkDef, fn)
	}
}

func addConsistencyCheck(chkName string, chkDef definition) {
	var chkRE string

	chkDef.Type = chkName
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
	for v1, v2 := range chkDef.Map {
		count += 2
		subs := []string{
			fmt.Sprintf("%s%d", chkKey, count), fmt.Sprintf("%s%d", chkKey, count+1)}

		chkRE = fmt.Sprintf("(?P<%s>%s)|(?P<%s>%s)", subs[0], v1, subs[1], v2)
		chkRE = fmt.Sprintf(regex, chkRE)
		re, err := regexp.Compile(chkRE)
		if util.CheckError(err, chkName) {
			chkDef.Type = chkName
			fn := func(text string, file *File) []Alert {
				return consistency(text, chkDef, file, re, subs)
			}
			updateAllChecks(chkDef, fn)
		}
	}
}

func addExistenceCheck(chkName string, chkDef definition) {
	chkDef.Type = chkName
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
			return existence(text, chkDef, file, re)
		}
		updateAllChecks(chkDef, fn)
	}
}

func addRepetitionCheck(chkName string, chkDef definition) {
	chkDef.Type = chkName

	regex := ""
	if chkDef.Ignorecase {
		regex += ignoreCase
	}
	regex += `(` + strings.Join(chkDef.Tokens, "|") + `)`
	re, err := regexp.Compile(regex)
	if util.CheckError(err, chkName) {
		fn := func(text string, file *File) []Alert {
			return repetition(text, chkDef, file, re)
		}
		updateAllChecks(chkDef, fn)
	}
}

func addOccurrenceCheck(chkName string, chkDef definition) {
	chkDef.Type = chkName

	re, err := regexp.Compile(chkDef.Tokens[0])
	if util.CheckError(err, chkName) && chkDef.Max >= 1 {
		fn := func(text string, file *File) []Alert {
			return occurrence(text, chkDef, file, re, chkDef.Max)
		}
		updateAllChecks(chkDef, fn)
	}
}

func addConditionalCheck(chkName string, chkDef definition) {
	var re *regexp.Regexp
	var expression []*regexp.Regexp
	var err error

	re, err = regexp.Compile(chkDef.Then)
	if !util.CheckError(err, chkName) {
		return
	}
	expression = append(expression, re)

	re, err = regexp.Compile(chkDef.If)
	if !util.CheckError(err, chkName) {
		return
	}
	expression = append(expression, re)

	chkDef.Type = chkName
	fn := func(text string, file *File) []Alert {
		return conditional(text, chkDef, file, expression)
	}
	updateAllChecks(chkDef, fn)
}

func addSubstitutionCheck(chkName string, chkDef definition) {
	chkDef.Type = chkName
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
	for regexstr, replacement := range chkDef.Map {
		tokens += `(` + regexstr + `)|`
		replacements = append(replacements, replacement)
	}

	regex = fmt.Sprintf(regex, strings.TrimRight(tokens, "|"))
	re, err := regexp.Compile(regex)
	if util.CheckError(err, "addSubstitutionCheck") {
		fn := func(text string, file *File) []Alert {
			return substitution(text, chkDef, file, re, replacements)
		}
		updateAllChecks(chkDef, fn)
	}
}

func updateAllChecks(chkDef definition, fn ruleFn) {
	chk := check{}
	chk.rule = fn
	chk.level = util.LevelToInt[chkDef.Level]
	chk.scope = Selector{Value: chkDef.Scope}
	AllChecks[chkDef.Type] = chk
}

func addCheck(file []byte, chkName string) {
	chkDef := definition{}
	err := yaml.Unmarshal(file, &chkDef)
	if !util.CheckError(err, chkName) {
		return
	}

	if !util.StringInSlice(chkDef.Level, util.AlertLevels) {
		chkDef.Level = "suggestion"
	}

	if chkDef.Scope == "" {
		chkDef.Scope = "text"
	}

	if addCheckFunc, ok := typeToFunc[chkDef.Type]; ok {
		addCheckFunc(chkName, chkDef)
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
		addCheck(b, "txtlint."+chk)
	}
}

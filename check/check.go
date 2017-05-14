package check

import (
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"

	"github.com/ValeLint/vale/core"
	"github.com/ValeLint/vale/rule"
	"github.com/jdkato/prose/transform"
	"github.com/mitchellh/mapstructure"
	"gopkg.in/yaml.v2"
	"matloob.io/regexp"
)

const (
	ignoreCase      = `(?i)`
	wordTemplate    = `\b(?:%s)\b`
	nonwordTemplate = `(?:%s)`
)

type ruleFn func(string, *core.File) []core.Alert

// Load initializes AllChecks based on the user's configuration.
func Load() {
	var style, path string

	loadedStyles := []string{}
	loadDefaultChecks()
	if core.Config.StylesPath == "" {
		return
	}

	loadedStyles = append(loadedStyles, "vale")
	baseDir := core.Config.StylesPath
	for _, style = range core.Config.GBaseStyles {
		if style == "vale" {
			continue
		}
		loadExternalStyle(filepath.Join(baseDir, style))
		loadedStyles = append(loadedStyles, style)
	}

	for _, styles := range core.Config.SBaseStyles {
		for _, style := range styles {
			if !core.StringInSlice(style, loadedStyles) {
				loadExternalStyle(filepath.Join(baseDir, style))
				loadedStyles = append(loadedStyles, style)
			}
		}
	}

	for _, chk := range core.Config.Checks {
		if !strings.Contains(chk, ".") {
			continue
		}
		check := strings.Split(chk, ".")
		if !core.StringInSlice(check[0], loadedStyles) {
			fName := check[1] + ".yml"
			path = filepath.Join(baseDir, check[0], fName)
			core.CheckError(loadCheck(fName, path))
		}
	}
}

func formatMessages(msg string, desc string, subs ...string) (string, string) {
	return core.FormatMessage(msg, subs...), core.FormatMessage(desc, subs...)
}

func makeAlert(chk Definition, loc []int, txt string) core.Alert {
	a := core.Alert{Check: chk.Name, Severity: chk.Level, Span: loc, Link: chk.Link}
	a.Message, a.Description = formatMessages(chk.Message, chk.Description,
		txt[loc[0]:loc[1]])
	return a
}

func checkConditional(txt string, chk Conditional, f *core.File, r []*regexp.Regexp) []core.Alert {
	alerts := []core.Alert{}

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
			if !core.StringInSlice(s, f.Sequences) && !core.StringInSlice(s, chk.Exceptions) {
				alerts = append(alerts, makeAlert(chk.Definition, loc, txt))
			}
		}
	}
	return alerts
}

func checkExistence(txt string, chk Existence, f *core.File, r *regexp.Regexp) []core.Alert {
	alerts := []core.Alert{}
	locs := r.FindAllStringIndex(txt, -1)
	if locs != nil {
		for _, loc := range locs {
			alerts = append(alerts, makeAlert(chk.Definition, loc, txt))
		}
	}
	return alerts
}

func checkOccurrence(txt string, chk Occurrence, f *core.File, r *regexp.Regexp, lim int) []core.Alert {
	var loc []int

	alerts := []core.Alert{}
	locs := r.FindAllStringIndex(txt, -1)
	occurrences := len(locs)
	if occurrences > lim {
		loc = []int{locs[0][0], locs[occurrences-1][1]}
		a := core.Alert{Check: chk.Name, Severity: chk.Level, Span: loc,
			Link: chk.Link}
		a.Message = chk.Message
		a.Description = chk.Description
		alerts = append(alerts, a)
	}

	return alerts
}

func checkRepetition(txt string, chk Repetition, f *core.File, r *regexp.Regexp) []core.Alert {
	var curr, prev string
	var hit bool
	var ploc []int
	var count int

	alerts := []core.Alert{}
	for _, loc := range r.FindAllStringIndex(txt, -1) {
		curr = strings.TrimSpace(txt[loc[0]:loc[1]])
		if chk.Ignorecase {
			hit = strings.ToLower(curr) == strings.ToLower(prev) && curr != ""
		} else {
			hit = curr == prev && curr != ""
		}
		if hit {
			count++
		}
		if hit && count > chk.Max {
			floc := []int{ploc[0], loc[1]}
			a := core.Alert{Check: chk.Name, Severity: chk.Level, Span: floc,
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

func checkSubstitution(txt string, chk Substitution, f *core.File, r *regexp.Regexp, repl []string) []core.Alert {
	alerts := []core.Alert{}
	if !r.MatchString(txt) {
		return alerts
	}

	for _, submat := range r.FindAllStringSubmatchIndex(txt, -1) {
		for idx, mat := range submat {
			if mat != -1 && idx > 0 && idx%2 == 0 {
				loc := []int{mat, submat[idx+1]}
				expected := repl[(idx/2)-1]
				observed := txt[loc[0]:loc[1]]
				if expected != observed {
					a := core.Alert{Check: chk.Name, Severity: chk.Level, Span: loc,
						Link: chk.Link}
					a.Message, a.Description = formatMessages(chk.Message,
						chk.Description, expected, observed)
					alerts = append(alerts, a)
				}
			}
		}
	}

	return alerts
}

func checkConsistency(txt string, chk Consistency, f *core.File, r *regexp.Regexp, opts []string) []core.Alert {
	alerts := []core.Alert{}
	loc := []int{}

	matches := r.FindAllStringSubmatchIndex(txt, -1)
	for _, submat := range matches {
		for idx, mat := range submat {
			if mat != -1 && idx > 0 && idx%2 == 0 {
				loc = []int{mat, submat[idx+1]}
				f.Sequences = append(f.Sequences, r.SubexpNames()[idx/2])
			}
		}
	}

	if matches != nil && core.AllStringsInSlice(opts, f.Sequences) {
		chk.Name = chk.Extends
		alerts = append(alerts, makeAlert(chk.Definition, loc, txt))
	}
	return alerts
}

func checkCapitalization(txt string, chk Capitalization, f *core.File) []core.Alert {
	alerts := []core.Alert{}
	if !chk.Check(txt) {
		alerts = append(alerts, makeAlert(chk.Definition, []int{0, len(txt)}, txt))
	}
	return alerts
}

func addCapitalizationCheck(chkName string, chkDef Capitalization) {
	if chkDef.Match == "$title" {
		var tc *transform.TitleConverter
		if chkDef.Style == "Chicago" {
			tc = transform.NewTitleConverter(transform.ChicagoStyle)
		} else {
			tc = transform.NewTitleConverter(transform.APStyle)
		}
		chkDef.Check = func(s string) bool { return title(s, tc) }
	} else if f, ok := varToFunc[chkDef.Match]; ok {
		chkDef.Check = f
	} else {
		re, err := regexp.Compile(chkDef.Match)
		if !core.CheckError(err) {
			return
		}
		chkDef.Check = re.MatchString
	}
	fn := func(text string, file *core.File) []core.Alert {
		return checkCapitalization(text, chkDef, file)
	}
	updateAllChecks(chkDef.Definition, fn)
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
		if core.CheckError(err) {
			chkDef.Extends = chkName
			chkDef.Name = fmt.Sprintf("%s.%s", chkName, v1)
			fn := func(text string, file *core.File) []core.Alert {
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
	if core.CheckError(err) {
		fn := func(text string, file *core.File) []core.Alert {
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
	if core.CheckError(err) {
		fn := func(text string, file *core.File) []core.Alert {
			return checkRepetition(text, chkDef, file, re)
		}
		updateAllChecks(chkDef.Definition, fn)
	}
}

func addOccurrenceCheck(chkName string, chkDef Occurrence) {
	re, err := regexp.Compile(chkDef.Token)
	if core.CheckError(err) && chkDef.Max >= 1 {
		fn := func(text string, file *core.File) []core.Alert {
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
	if !core.CheckError(err) {
		return
	}
	expression = append(expression, re)

	re, err = regexp.Compile(chkDef.First)
	if !core.CheckError(err) {
		return
	}
	expression = append(expression, re)

	fn := func(text string, file *core.File) []core.Alert {
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
	if core.CheckError(err) {
		fn := func(text string, file *core.File) []core.Alert {
			return checkSubstitution(text, chkDef, file, re, replacements)
		}
		updateAllChecks(chkDef.Definition, fn)
	}
}

func updateAllChecks(chkDef Definition, fn ruleFn) {
	chk := Check{Rule: fn, Extends: chkDef.Extends}
	chk.Level = core.LevelToInt[chkDef.Level]
	chk.Scope = core.Selector{Value: chkDef.Scope}
	AllChecks[chkDef.Name] = chk
}

func makeCheck(generic map[string]interface{}, extends string, chkName string) {
	// TODO: make this less ugly ...
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
	} else if extends == "capitalization" {
		def := Capitalization{}
		if err := mapstructure.Decode(generic, &def); err == nil {
			addCapitalizationCheck(chkName, def)
		}
	}
}

func validateDefinition(generic map[string]interface{}, name string) error {
	msg := name + ": %s!"
	if point, ok := generic["extends"]; !ok {
		return fmt.Errorf(msg, "missing extension point")
	} else if !core.StringInSlice(point.(string), extensionPoints) {
		return fmt.Errorf(msg, "unknown extension point")
	} else if _, ok := generic["message"]; !ok {
		return fmt.Errorf(msg, "missing message")
	}
	return nil
}

func addCheck(file []byte, chkName string) error {
	// Load the rule definition.
	generic := map[string]interface{}{}
	err := yaml.Unmarshal(file, &generic)
	if err != nil {
		return fmt.Errorf("%s: %s", chkName, err.Error())
	} else if defErr := validateDefinition(generic, chkName); defErr != nil {
		return defErr
	}

	// Set default values, if necessary.
	generic["name"] = chkName
	if level, ok := core.Config.RuleToLevel[chkName]; ok {
		generic["level"] = level
	} else if _, ok := generic["level"]; !ok {
		generic["level"] = "warning"
	}
	if _, ok := generic["scope"]; !ok {
		generic["scope"] = "text"
	}

	makeCheck(generic, generic["extends"].(string), chkName)
	return nil
}

func loadExternalStyle(path string) {
	err := filepath.Walk(path,
		func(fp string, fi os.FileInfo, err error) error {
			if err != nil || fi.IsDir() {
				return nil
			}
			core.CheckError(loadCheck(fi.Name(), fp))
			return nil
		})
	core.CheckError(err)
}

func loadCheck(fName string, fp string) error {
	if strings.HasSuffix(fName, ".yml") {
		f, err := ioutil.ReadFile(fp)
		if !core.CheckError(err) {
			return err
		}

		style := filepath.Base(filepath.Dir(fp))
		chkName := style + "." + strings.Split(fName, ".")[0]
		if _, ok := AllChecks[chkName]; ok {
			return fmt.Errorf("(%s): duplicate check", chkName)
		}
		return addCheck(f, chkName)
	}
	return nil
}

func loadDefaultChecks() {
	for _, chk := range defaultChecks {
		b, err := rule.Asset("rule/" + chk + ".yml")
		if err != nil {
			continue
		}
		core.CheckError(addCheck(b, "vale."+chk))
	}
}

package ui

import (
	"errors"
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
	"strings"

	"github.com/acarl005/stripansi"
	"github.com/errata-ai/vale/v2/config"
	"github.com/mattn/go-colorable"
)

type valeError struct {
	line int
	path string
	text string
	code string
	span int
}

var logger = log.New(os.Stderr, "", 0)
var header = regexp.MustCompile(`(\w+) .+ \[(.+):(\d+):(\d+)\]`)

func init() {
	// https://github.com/logrusorgru/aurora/issues/2#issuecomment-299014211
	logger.SetOutput(colorable.NewColorableStderr())
}

func parseError(err error) (valeError, error) {
	var parsed valeError

	plain := stripansi.Strip(err.Error())
	lines := strings.Split(plain, "\n\n")

	if len(lines) < 3 {
		return parsed, errors.New("missing body")
	} else if !header.MatchString(lines[0]) {
		return parsed, errors.New("missing header")
	}

	groups := header.FindStringSubmatch(lines[0])

	parsed.code = groups[1]
	parsed.path = groups[2]

	i, err := strconv.Atoi(groups[3])
	if err != nil {
		return parsed, errors.New("missing line")
	}
	parsed.line = i

	i, err = strconv.Atoi(groups[4])
	if err != nil {
		return parsed, errors.New("missing span")
	}
	parsed.span = i

	parsed.text = lines[len(lines)-2]
	return parsed, nil
}

// ShowError displays the given error in the user-specified format.
func ShowError(err error, config *config.Config) {
	parsed, failed := parseError(err)
	switch config.Output {
	case "JSON":
		var data interface{}

		if failed != nil {
			data = struct {
				Code string
				Text string
			}{
				Text: err.Error(),
				Code: "E100",
			}
		} else {
			data = struct {
				Line int
				Path string
				Text string
				Code string
				Span int
			}{
				Line: parsed.line,
				Path: parsed.path,
				Text: parsed.text,
				Code: parsed.code,
				Span: parsed.span,
			}
		}

		logger.Fatalln(getJSON(data))
	case "line":
		var data string

		if failed != nil {
			data = err.Error()
		} else {
			data = fmt.Sprintf("%s:%d:%s:%s",
				parsed.path, parsed.line, parsed.code, parsed.text)
		}

		logger.Fatalln(data)
	default:
		logger.Fatalln(err)
	}
}

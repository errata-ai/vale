package core

import (
	"path/filepath"
	"strings"

	"github.com/jdkato/regexp"
)

// CommentsByNormedExt determines what parts of a file we should lint -- e.g.,
// we only want to lint // or /* comments in a C++ file. Multiple formats are
// mapped to a single extension (e.g., .java -> .c) because many languages use
// the same comment delimiters.
var CommentsByNormedExt = map[string]map[string]string{
	".c": {
		"inline":     `(?:^|\s)(?:(//.+)|(/\*.+\*/))`,
		"blockStart": `(/\*.*)`,
		"blockEnd":   `(.*\*/)`,
	},
	".css": {
		"inline":     `(/\*.+\*/)`,
		"blockStart": `(/\*.*)`,
		"blockEnd":   `(.*\*/)`,
	},
	".rs": {
		"inline":     `(//.+)`,
		"blockStart": `$^`,
		"blockEnd":   `$^`,
	},
	".r": {
		"inline":     `(#.+)`,
		"blockStart": `$^`,
		"blockEnd":   `$^`,
	},
	".py": {
		"inline":     `(#.*)|('{3}.+'{3})|("{3}.+"{3})`,
		"blockStart": `(?m)^((?:\s{4,})?[r]?["']{3}.*)$`,
		"blockEnd":   `(.*["']{3})`,
	},
	".php": {
		"inline":     `(//.+)|(/\*.+\*/)|(#.+)`,
		"blockStart": `(/\*.*)`,
		"blockEnd":   `(.*\*/)`,
	},
	".lua": {
		"inline":     `(-- .+)`,
		"blockStart": `(-{2,3}\[\[.*)`,
		"blockEnd":   `(.*\]\])`,
	},
	".hs": {
		"inline":     `(-- .+)`,
		"blockStart": `(\{-.*)`,
		"blockEnd":   `(.*-\})`,
	},
	".rb": {
		"inline":     `(#.+)`,
		"blockStart": `(^=begin)`,
		"blockEnd":   `(^=end)`,
	},
}

// FormatByExtension associates a file extension with its "normed" extension
// and its format (markup, code or text).
var FormatByExtension = map[string][]string{
	`\.(?:[rc]?py[3w]?|[Ss][Cc]onstruct)$`:        {".py", "code"},
	`\.(?:adoc|asciidoc|asc)$`:                    {".adoc", "markup"},
	`\.(?:cpp|cc|c|cp|cxx|c\+\+|h|hpp|h\+\+)$`:    {".c", "code"},
	`\.(?:cs|csx)$`:                               {".c", "code"},
	`\.(?:css)$`:                                  {".css", "code"},
	`\.(?:go)$`:                                   {".c", "code"},
	`\.(?:html|htm|shtml|xhtml)$`:                 {".html", "markup"},
	`\.(?:rb|Gemfile|Rakefile|Brewfile|gemspec)$`: {".rb", "code"},
	`\.(?:java|bsh)$`:                             {".c", "code"},
	`\.(?:js)$`:                                   {".c", "code"},
	`\.(?:lua)$`:                                  {".lua", "code"},
	`\.(?:md|mdown|markdown|markdn)$`:             {".md", "markup"},
	`\.(?:php)$`:                                  {".php", "code"},
	`\.(?:pl|pm|pod)$`:                            {".r", "code"},
	`\.(?:r|R)$`:                                  {".r", "code"},
	`\.(?:rs)$`:                                   {".rs", "code"},
	`\.(?:rst|rest)$`:                             {".rst", "markup"},
	`\.(?:swift)$`:                                {".c", "code"},
	`\.(?:txt)$`:                                  {".txt", "text"},
	`\.(?:sass|less)$`:                            {".c", "code"},
	`\.(?:scala|sbt)$`:                            {".c", "code"},
	`\.(?:hs)$`:                                   {".hs", "code"},
	`\.(?:xml)$`:                                  {".xml", "markup"},
	`\.(?:dita)$`:                                 {".dita", "markup"},
}

// FormatFromExt takes a file extension and returns its [normExt, format]
// list, if supported.
func FormatFromExt(path string, mapping map[string]string) (string, string) {
	ext := strings.Trim(filepath.Ext(path), ".")
	if format, found := mapping[ext]; found {
		ext = format
	}
	ext = "." + ext
	for r, f := range FormatByExtension {
		m, _ := regexp.MatchString(r, ext)
		if m {
			return f[0], f[1]
		}
	}
	return "unknown", "unknown"
}

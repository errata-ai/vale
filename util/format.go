package util

// CommentsByNormedExt determines what parts of a file we should lint -- e.g.,
// we only want to lint // or /* comments in a C++ file. Multiple syntaxes are
// mapped to a single extension (e.g., .java -> .c) because many languages use
// the same comment delimiters.
var CommentsByNormedExt = map[string]map[string]string{
	".c": {
		"inline":     `(//.+)|(/\*.+\*/)`,
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

// MatchIgnoreByByExtension maps an inline ignore pattern to its format
// (such as `foo` in Markdown).
var MatchIgnoreByByExtension = map[string]string{
	".md":   "`([^`]+)`",
	".rst":  "``([^`]+)``|:.+:`[^`]+`",
	".adoc": "`([^`]+)`",
}

// LookupSyntaxName associates a syntax name with an extension used to get its
// comment delimiters from CommentsByNormedExt. An example use case is Markdown
// codeblocks: given a syntax (e.g., ```python), we use this to get its
// associated comments.
var LookupSyntaxName = map[string]string{
	`(?:(?i)C|C\+\+|C#|Java|JavaScript|js|Swift|Go|sass|less|scala)$`: ".c",
	`(?:(?i)lua)$`:        ".lua",
	`(?:(?i)PHP)$`:        ".php",
	`(?:(?i)Python|py)$`:  ".py",
	`(?:(?i)R|perl)$`:     ".r",
	`(?:(?i)Rust)$`:       ".rs",
	`(?:(?i)Haskell|hs)$`: ".hs",
	`(?:(?i)Ruby|rb)$`:    ".rb",
}

// FormatByExtension associates a file extension with its "normed" extension
// and its format (markup, code or text).
var FormatByExtension = map[string][]string{
	`\.(?:[rc]?py[3w]?|[Ss][Cc]onstruct)$`:        {".py", "code"},
	`\.(?:adoc|asciidoc)$`:                        {".adoc", "markup"},
	`\.(?:cpp|cc|c|cp|cxx|c\+\+|h|hpp|h\+\+)$`:    {".c", "code"},
	`\.(?:cs|csx)$`:                               {".c", "code"},
	`\.(?:css)$`:                                  {".css", "code"},
	`\.(?:go)$`:                                   {".c", "code"},
	`\.(?:html|htm|shtml|xhtml)$`:                 {".html", "markup"},
	`\.(?:java|bsh)$`:                             {".c", "code"},
	`\.(?:js)$`:                                   {".c", "code"},
	`\.(?:ltx|tex)$`:                              {".tex", "markup"},
	`\.(?:lua)$`:                                  {".lua", "code"},
	`\.(?:md|mdown|markdown|markdn)$`:             {".md", "markup"},
	`\.(?:php)$`:                                  {".php", "code"},
	`\.(?:pl|pm|pod)$`:                            {".r", "code"},
	`\.(?:r|R)$`:                                  {".r", "code"},
	`\.(?:rs)$`:                                   {".rs", "code"},
	`\.(?:rst|rest)$`:                             {".rst", "markup"},
	`\.(?:swift)$`:                                {".c", "code"},
	`\.(?:txt)$`:                                  {".txt", "text"},
	`\.(?:rb|Gemfile|Rakefile|Brewfile|gemspec)$`: {".rb", "code"},
	`\.(?:sass|less)$`:                            {".c", "code"},
	`\.(?:scala|sbt)$`:                            {".c", "code"},
	`\.(?:hs)$`:                                   {".hs", "code"},
}

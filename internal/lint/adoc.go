package lint

import (
	"bytes"
	"errors"
	"io/ioutil"
	"os"
	"os/exec"
	"strings"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/jdkato/regexp"
)

// NOTE: Asciidoctor converts "'" to "’".
//
// See #206.
var adocSanitizer = strings.NewReplacer(
	"\u2018", "&apos;",
	"\u2019", "&apos;",
	"\u201C", "&#8220;",
	"\u201D", "&#8221;",
	"&#8217;", "&apos;",
	"&rsquo;", "&apos;")

// Convert listing blocks of the form `[source,.+]` to `[source]`
var reSource = regexp.MustCompile(`\[source,.+\]`)

var adocArgs = []string{
	"-s",
	"-a",
	"notitle!",
	"-a",
	"attribute-missing=drop",
	"--quiet",
	"--safe-mode",
	"secure",
	"-",
}
var homes = []*regexp.Regexp{
	// Homebrew
	regexp.MustCompile(`(?m)GEM_HOME="(.+?)"`),
	// rbenv
	regexp.MustCompile(`(?m)^exec "(.+?)"`),
}

var adocDomain = "localhost:7070"
var adocURL = "http://" + adocDomain

var adocRunning = false
var adocServer = `require 'socket'
require 'asciidoctor'

server = TCPServer.new("localhost", 7070)

loop do
  socket = server.accept

  headers = {}
  while message = socket.gets
   line = message.split(' ', 2)
   break if line[0] == ""
   headers[line[0].chop] = line[1].chop
  end

  data = socket.read(headers["Content-Length"].to_i)
  next if data.strip == "" # TODO: Why?

  data = data.encode("utf-8", :invalid => :replace, :undef => :replace, :replace => '')
  response = Asciidoctor.convert(data, :header_footer => false, # -s
                :attributes => %w(notitle! attribute-missing=drop),
                :safe => :secure)

  socket.print "HTTP/1.1 200 OK\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n"

  socket.print "\r\n"
  socket.print response

  socket.close
end`

func (l *Linter) lintADoc(f *core.File) error {
	var html string
	var err error

	exe := core.Which([]string{"asciidoctor"})
	if exe == "" {
		return core.NewE100("lintAdoc", errors.New("asciidoctor not found"))
	}

	s, err := l.prep(f.Content, "\n----\n$1\n----\n", "`$1`", ".adoc")
	if err != nil {
		return err
	}

	s = adocSanitizer.Replace(s)
	if err := l.startAdocServer(exe); err != nil {
		html, err = callAdoc(f, s, exe)
	} else {
		html, err = l.post(f, s, adocURL)
	}

	if err != nil {
		return core.NewE100(f.Path, err)
	}

	html = adocSanitizer.Replace(html)
	body := reSource.ReplaceAllStringFunc(f.Content, func(m string) string {
		// NOTE: This is required to avoid finding matches in block attributes.
		//
		// See https://github.com/errata-ai/vale/issues/296.
		parts := strings.Split(m, ",")
		span := strings.Repeat("*", len(parts[len(parts)-1])-2)
		return "[source, " + span + "]"
	})

	f.Content = body
	return l.lintHTMLTokens(f, []byte(html), 0)
}

func (l *Linter) startAdocServer(exe string) error {
	if adocRunning {
		return nil
	}

	ruby := core.Which([]string{"ruby", "jruby"})
	if ruby == "" {
		return core.NewE100("startAdoc", errors.New("ruby not found"))
	}

	home, err := findGems(exe)
	if err != nil {
		return err
	} else if home == "" {
		return errors.New("GEM_HOME parsing failed")
	}

	tmpfile, _ := ioutil.TempFile("", "server.*.rb")
	if _, err := tmpfile.WriteString(adocServer); err != nil {
		return err
	}

	if err := tmpfile.Close(); err != nil {
		return err
	}

	cmd := exec.Command(ruby, tmpfile.Name())
	cmd.Env = append(os.Environ(),
		"GEM_HOME="+home,
	)

	if err := cmd.Start(); err != nil {
		return err
	}

	ping(adocDomain)

	l.pids = append(l.pids, cmd.Process.Pid)
	l.temps = append(l.temps, tmpfile)

	adocRunning = true
	return nil
}

func callAdoc(f *core.File, text, exe string) (string, error) {
	var out bytes.Buffer

	cmd := exec.Command(exe, adocArgs...)
	cmd.Stdin = strings.NewReader(text)
	cmd.Stdout = &out

	if err := cmd.Run(); err != nil {
		return "", core.NewE100(f.Path, err)
	}

	return out.String(), nil
}

func findGems(exe string) (string, error) {
	var home string

	for _, v := range []string{"GEM_HOME"} {
		canidate := os.Getenv(v)
		if canidate != "" {
			return canidate, nil
		}
	}

	bin, err := ioutil.ReadFile(exe)
	if err != nil {
		return home, err
	}

	f := string(bin)
	for _, opt := range homes {
		m := opt.FindStringSubmatch(f)
		if len(m) > 1 {
			home = m[1]
		}
	}

	return home, nil
}

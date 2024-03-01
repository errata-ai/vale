package lint

import (
	"bytes"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"regexp"
	"strings"

	"github.com/errata-ai/vale/v3/internal/core"
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
var reComment = regexp.MustCompile(`// .+`)

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
                :attributes => %w(ATTRS),
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

	s, err := l.Transform(f)
	if err != nil {
		return err
	}
	s = adocSanitizer.Replace(s)

	attrs := l.Manager.Config.Asciidoctor
	if !l.HasDir {
		html, err = callAdoc(f, s, exe, attrs)
		if err != nil {
			return core.NewE100(f.Path, err)
		}
	} else if err = l.startAdocServer(exe, attrs); err != nil {
		html, err = callAdoc(f, s, exe, attrs)
		if err != nil {
			return core.NewE100(f.Path, err)
		}
	} else {
		html, err = l.post(f, s, adocURL)
		if err != nil {
			html, err = callAdoc(f, s, exe, attrs)
			if err != nil {
				return core.NewE100(f.Path, err)
			}
		}
	}

	html = adocSanitizer.Replace(html)
	body := reSource.ReplaceAllStringFunc(f.Content, func(m string) string {
		offset := 0
		if strings.HasSuffix(m, ",]") {
			offset = 1
			m = strings.Replace(m, ",]", "]", 1)
		}
		// NOTE: This is required to avoid finding matches in block attributes.
		//
		// See https://github.com/errata-ai/vale/issues/296.
		parts := strings.Split(m, ",")
		span := strings.Repeat("*", len(parts[len(parts)-1])-2+offset)
		return "[source, " + span + "]"
	})

	body = reComment.ReplaceAllStringFunc(body, func(m string) string {
		// NOTE: This is required to avoid finding matches in line comments.
		//
		// See https://github.com/errata-ai/vale/issues/414.
		//
		// TODO: Multiple line comments are not handled correctly.
		//
		// https://docs.asciidoctor.org/asciidoc/latest/comments/
		parts := strings.Split(m, "//")
		span := strings.Repeat("*", len(parts[1])-1)
		return "// " + span
	})

	f.Content = body
	return l.lintHTMLTokens(f, []byte(html), 0)
}

func (l *Linter) startAdocServer(exe string, attrs map[string]string) error {
	if adocRunning {
		return nil
	}

	var adocArgs = []string{
		"notitle!",
		"attribute-missing=drop",
	}
	adocArgs = append(adocArgs, parseAttributes(attrs)...)

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

	adocServer = strings.Replace(
		adocServer,
		"ATTRS",
		strings.Join(adocArgs, " "),
		1,
	)

	tmpfile, _ := os.CreateTemp("", "server.*.rb")
	if _, err = tmpfile.WriteString(adocServer); err != nil {
		return err
	}

	if err = tmpfile.Close(); err != nil {
		return err
	}

	cmd := exec.Command(ruby, tmpfile.Name())
	cmd.Env = append(os.Environ(),
		"GEM_HOME="+home,
	)

	if err = cmd.Start(); err != nil {
		return err
	}

	l.pids = append(l.pids, cmd.Process.Pid)
	l.temps = append(l.temps, tmpfile)

	if err = ping(adocDomain); err != nil {
		return err
	}

	adocRunning = true
	return nil
}

func callAdoc(_ *core.File, text, exe string, attrs map[string]string) (string, error) {
	var out bytes.Buffer
	var eut bytes.Buffer

	var adocArgs = []string{
		"-s",
		"-a",
		"notitle!",
		"-a",
		"attribute-missing=drop",
	}

	adocArgs = append(adocArgs, parseAttributes(attrs)...)
	adocArgs = append(adocArgs, []string{"--safe-mode", "secure", "-"}...)

	cmd := exec.Command(exe, adocArgs...)
	cmd.Stdin = strings.NewReader(text)
	cmd.Stdout = &out
	cmd.Stderr = &eut

	if err := cmd.Run(); err != nil {
		return "", errors.New(eut.String())
	}

	return out.String(), nil
}

func findGems(exe string) (string, error) {
	var home string

	for _, v := range []string{"GEM_HOME"} {
		candidate := os.Getenv(v)
		if candidate != "" {
			return candidate, nil
		}
	}

	bin, err := os.ReadFile(exe)
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

func parseAttributes(attrs map[string]string) []string {
	var adocArgs []string

	for k, v := range attrs {
		entry := fmt.Sprintf("%s=%s", k, v)
		if v == "YES" {
			entry = k
		} else if v == "NO" {
			entry = k + "!"
		}
		adocArgs = append(adocArgs, []string{"-a", entry}...)
	}

	return adocArgs
}

package lint

import (
	"bytes"
	"errors"
	"fmt"
	"io/ioutil"
	"net"
	"net/http"
	"strings"
	"time"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/gobwas/glob"
	"github.com/jdkato/regexp"
)

var reFrontMatter = regexp.MustCompile(
	`^(?s)(?:---|\+\+\+)\n(.+?)\n(?:---|\+\+\+)`)

var heading = regexp.MustCompile(`^h\d$`)

func (l *Linter) lintHTML(f *core.File) error {
	if l.Manager.Config.Flags.Built != "" {
		return l.lintTxtToHTML(f)
	}
	return l.lintHTMLTokens(f, []byte(f.Content), 0)
}

func (l *Linter) prep(content, block, inline, ext string) (string, error) {
	s := reFrontMatter.ReplaceAllString(content, block)

	for syntax, regexes := range l.Manager.Config.TokenIgnores {
		sec, err := glob.Compile(syntax)
		if err != nil {
			return s, err
		} else if sec.Match(ext) {
			for _, r := range regexes {
				pat, err := regexp.Compile(r)
				if err != nil {
					return s, core.NewE201FromTarget(
						err.Error(),
						r,
						l.Manager.Config.Flags.Path,
					)
				}
				s = pat.ReplaceAllString(s, inline)
			}
		}
	}

	for syntax, regexes := range l.Manager.Config.BlockIgnores {
		sec, err := glob.Compile(syntax)
		if err != nil {
			return s, err
		} else if sec.Match(ext) {
			for _, r := range regexes {
				pat, err := regexp.Compile(r)
				if err != nil {
					return s, core.NewE201FromTarget(
						err.Error(),
						r,
						l.Manager.Config.Flags.Path,
					)
				} else if ext == ".rst" {
					// HACK: We need to add padding for the literal block.
					for _, c := range pat.FindAllStringSubmatch(s, -1) {
						new := fmt.Sprintf(block, core.Indent(c[0], "    "))
						s = strings.Replace(s, c[0], new, 1)
					}
				} else {
					s = pat.ReplaceAllString(s, block)
				}
			}
		}
	}

	return s, nil
}

func (l *Linter) post(f *core.File, text, url string) (string, error) {
	req, err := http.NewRequest("POST", url, bytes.NewBufferString(text))
	if err != nil {
		return "", core.NewE100(f.Path, err)
	}
	req.Header.Set("Content-Type", "text/plain")
	req.Header.Set("Accept", "text/plain")

	resp, err := l.client.Do(req)
	if err != nil {
		return "", core.NewE100(f.Path, err)
	}
	defer resp.Body.Close()

	body, _ := ioutil.ReadAll(resp.Body)
	if resp.StatusCode == 200 {
		return string(body), nil
	}

	return "", core.NewE100(f.Path, errors.New("bad status"))
}

func (l *Linter) lintTxtToHTML(f *core.File) error {
	html, err := ioutil.ReadFile(l.Manager.Config.Flags.Built)
	if err != nil {
		return core.NewE100(f.Path, err)
	}
	return l.lintHTMLTokens(f, html, 0)
}

func ping(domain string) {
	for {
		conn, err := net.DialTimeout("tcp", domain, 2*time.Millisecond)
		if err == nil {
			conn.Close()
			break
		}
	}
}

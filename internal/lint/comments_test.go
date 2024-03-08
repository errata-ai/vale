package lint

import (
	"bytes"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func toMarkup(comments []Comment) string {
	var markup bytes.Buffer

	for _, comment := range comments {
		markup.WriteString(strings.TrimLeft(comment.Text, " "))
	}

	return markup.String()
}

func TestComments(t *testing.T) {
	var cleaned []fs.DirEntry

	cases, err := os.ReadDir("../../testdata/comments/in")
	if err != nil {
		t.Error(err)
	}

	for _, f := range cases {
		if f.Name() == ".DS_Store" {
			continue
		}
		cleaned = append(cleaned, f)
	}

	for i, f := range cleaned {
		b, err1 := os.ReadFile(fmt.Sprintf("../../testdata/comments/in/%s", f.Name()))
		if err1 != nil {
			t.Error(err1)
		}
		comments := getComments(string(b), filepath.Ext(f.Name()))

		b2, err2 := os.ReadFile(fmt.Sprintf("../../testdata/comments/out/%d.txt", i))
		if err2 != nil {
			t.Error(err2)
		}
		markup := toMarkup(comments)

		if markup != string(b2) {
			bin := filepath.Join("..", "..", "bin", fmt.Sprintf("%d.txt", i))
			err = os.WriteFile(bin, []byte(markup), os.ModePerm)
			if err != nil {
				t.Error(err)
			}
			t.Errorf("%s", markup)
		}
	}
}

func TestCommentsLexer(t *testing.T) {
	var cleaned []fs.DirEntry

	cases, err := os.ReadDir("../../testdata/comments/in")
	if err != nil {
		t.Error(err)
	}

	for _, f := range cases {
		if f.Name() == ".DS_Store" {
			continue
		}
		cleaned = append(cleaned, f)
	}

	for _, f := range cleaned {
		b, err1 := os.ReadFile(fmt.Sprintf("../../testdata/comments/in/%s", f.Name()))
		if err1 != nil {
			t.Error(err1)
		}

		comments, err := getCommentsLexer(string(b), filepath.Ext(f.Name()))
		if err != nil {
			t.Error(err)
		}

		fmt.Println(comments)
	}
}

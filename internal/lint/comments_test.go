package lint

import (
	"bytes"
	"fmt"
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
	cases, err := os.ReadDir("../../testdata/comments/in")
	if err != nil {
		t.Error(err)
	}

	for i, f := range cases {
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
			err = os.WriteFile(fmt.Sprintf("%d.txt", i), []byte(markup), os.ModePerm)
			if err != nil {
				t.Error(err)
			}
			t.Errorf("%s", markup)
		}
	}
}

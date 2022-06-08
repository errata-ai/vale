package lint

import (
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"testing"
)

func TestComments(t *testing.T) {
	cases, err := ioutil.ReadDir("../../testdata/comments/in")
	if err != nil {
		t.Error(err)
	}

	for i, f := range cases {
		b, err := ioutil.ReadFile(fmt.Sprintf("../../testdata/comments/in/%s", f.Name()))
		if err != nil {
			t.Error(err)
		}
		comments := getComments(string(b), filepath.Ext(f.Name()))

		b2, err := ioutil.ReadFile(fmt.Sprintf("../../testdata/comments/out/%d.txt", i))
		if err != nil {
			t.Error(err)
		}
		markup := toMarkup(comments)

		if markup != string(b2) {
			err = ioutil.WriteFile(fmt.Sprintf("%d.txt", i), []byte(markup), os.ModePerm)
			if err != nil {
				t.Error(err)
			}
			t.Errorf("%s", markup)
		}
	}
}
